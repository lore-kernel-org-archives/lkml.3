Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbaKTTmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 14:42:14 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:35044 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbaKTTmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 14:42:13 -0500
MIME-Version: 1.0
In-Reply-To: <20141031165136.GB32331@dtor-ws>
References: <1414693987-6059-1-git-send-email-benjamin.tissoires@redhat.com>
	<20141031165136.GB32331@dtor-ws>
Date: Thu, 20 Nov 2014 14:42:11 -0500
Message-ID: <CAN+gG=EBz6vifWoV5PmGzMNJgHD59F2P_6sZfDZU5hbkSOPoQQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Input: synaptics: Use in-kernel tracking for
 reporting mt data
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Hans de Goede <hdegoede@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chung-yih Wang <cywang@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 12:51 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Thu, Oct 30, 2014 at 02:33:06PM -0400, Benjamin Tissoires wrote:
>> The current code tries to consider all states and transitions to properly
>> detect which finger is attached to which slot. The code is quite huge
>> and difficult to read.
>> If the sensor manages to group the touch points but is not reliable in
>> giving tracking ids, we can simply use the kernel tracking method. Note
>> that it is already used by Cr-48 Chromebooks.
>>
>> Incidentaly, this fixes a bug reported by Peter Hutterer:
>> """
>> on the Lenovo T440, run:
>> evemu-record /dev/input/event4 | grep BTN_
>>
>> then put one, two, three, two fingers down
>> when you go from 3 to 2 fingers the driver sends a spurious BTN_TOUCH 0
>> event:
>>
>> E: 0.000000 0001 014a 0001      # EV_KEY / BTN_TOUCH            1
>> E: 0.000000 0001 0145 0001      # EV_KEY / BTN_TOOL_FINGER      1
>> E: 0.770008 0001 0145 0000      # EV_KEY / BTN_TOOL_FINGER      0
>> E: 0.770008 0001 014d 0001      # EV_KEY / BTN_TOOL_DOUBLETAP   1
>> E: 1.924716 0001 014d 0000      # EV_KEY / BTN_TOOL_DOUBLETAP   0
>> E: 1.924716 0001 014e 0001      # EV_KEY / BTN_TOOL_TRIPLETAP   1
>>
>> .. changing from 3 to 2 fingers now
>>
>> E: 3.152641 0001 014a 0000      # EV_KEY / BTN_TOUCH            0
>> E: 3.152641 0001 014d 0001      # EV_KEY / BTN_TOOL_DOUBLETAP   1
>> E: 3.152641 0001 014e 0000      # EV_KEY / BTN_TOOL_TRIPLETAP   0
>> E: 3.176948 0001 014a 0001      # EV_KEY / BTN_TOUCH            1
>>
>> quick look in the kernel shows it's caused by hw.z going to 0 for a packet,
>> so probably a firmware bug. either way, it makes it hard to track BTN_TOUCH
>> as signal that at least one finger is down.
>> """
>>
>> The in-kernel tracking is enough to remove this spurious BTN_TOUCH 0.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>
>> Hi Dmitry,
>>
>> I started working on that for 2 other bug reports
>> https://bugs.freedesktop.org/show_bug.cgi?id=81278
>> and
>> https://bugs.freedesktop.org/show_bug.cgi?id=76722
>>
>> I thought the cursor jumps could be fixed by the in-kernel tracking, but the
>> tracking needs a little bit more work to filter them out (patches to follow soon).
>>
>> From a user perspective, this patch does not change anything to what the user
>> previously had. It also fixes Peter's bug that's why I decide to send this out
>> by itself (removing ~350 lines of code and fixing bugs is always nice).
>>
>> I think the cursor jump fixes will need more bikeshedding in input-mt.c (I am
>> *really* bad at designing APIs), so I'll send it later as an RFC.
>
> Daniel and Chung-yih were working on the driver so let's see if they
> have a moment...
>

Any news from the chrome team? This is a requirement for fixing the
cursor jumps, and I'd rather have this series in shape before
introducing the changes in input-mt.c.

Cheers,
Benjamin

>>
>> Cheers,
>> Benjamin
>>
>>  drivers/input/mouse/synaptics.c | 397 ++++------------------------------------
>>  drivers/input/mouse/synaptics.h |  18 +-
>>  2 files changed, 34 insertions(+), 381 deletions(-)
>>
>> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
>> index 9031a0a..fd89249 100644
>> --- a/drivers/input/mouse/synaptics.c
>> +++ b/drivers/input/mouse/synaptics.c
>> @@ -569,14 +569,6 @@ static void synaptics_pt_create(struct psmouse *psmouse)
>>   *   Functions to interpret the absolute mode packets
>>   ****************************************************************************/
>>
>> -static void synaptics_mt_state_set(struct synaptics_mt_state *state, int count,
>> -                                int sgm, int agm)
>> -{
>> -     state->count = count;
>> -     state->sgm = sgm;
>> -     state->agm = agm;
>> -}
>> -
>>  static void synaptics_parse_agm(const unsigned char buf[],
>>                               struct synaptics_data *priv,
>>                               struct synaptics_hw_state *hw)
>> @@ -595,16 +587,13 @@ static void synaptics_parse_agm(const unsigned char buf[],
>>               break;
>>
>>       case 2:
>> -             /* AGM-CONTACT packet: (count, sgm, agm) */
>> -             synaptics_mt_state_set(&agm->mt_state, buf[1], buf[2], buf[4]);
>> +             /* AGM-CONTACT packet: we are only interested in the count */
>> +             priv->agm_count = buf[1];
>>               break;
>>
>>       default:
>>               break;
>>       }
>> -
>> -     /* Record that at least one AGM has been received since last SGM */
>> -     priv->agm_pending = true;
>>  }
>>
>>  static bool is_forcepad;
>> @@ -798,388 +787,68 @@ static void synaptics_report_buttons(struct psmouse *psmouse,
>>               input_report_key(dev, BTN_0 + i, hw->ext_buttons & (1 << i));
>>  }
>>
>> -static void synaptics_report_slot(struct input_dev *dev, int slot,
>> -                               const struct synaptics_hw_state *hw)
>> -{
>> -     input_mt_slot(dev, slot);
>> -     input_mt_report_slot_state(dev, MT_TOOL_FINGER, (hw != NULL));
>> -     if (!hw)
>> -             return;
>> -
>> -     input_report_abs(dev, ABS_MT_POSITION_X, hw->x);
>> -     input_report_abs(dev, ABS_MT_POSITION_Y, synaptics_invert_y(hw->y));
>> -     input_report_abs(dev, ABS_MT_PRESSURE, hw->z);
>> -}
>> -
>>  static void synaptics_report_mt_data(struct psmouse *psmouse,
>> -                                  struct synaptics_mt_state *mt_state,
>> -                                  const struct synaptics_hw_state *sgm)
>> +                                  const struct synaptics_hw_state *sgm,
>> +                                  int num_fingers)
>>  {
>>       struct input_dev *dev = psmouse->dev;
>>       struct synaptics_data *priv = psmouse->private;
>> -     struct synaptics_hw_state *agm = &priv->agm;
>> -     struct synaptics_mt_state *old = &priv->mt_state;
>> +     const struct synaptics_hw_state *hw[2] = { sgm, &priv->agm };
>> +     struct input_mt_pos pos[2];
>> +     int slot[2], nsemi, i;
>>
>> -     switch (mt_state->count) {
>> -     case 0:
>> -             synaptics_report_slot(dev, 0, NULL);
>> -             synaptics_report_slot(dev, 1, NULL);
>> -             break;
>> -     case 1:
>> -             if (mt_state->sgm == -1) {
>> -                     synaptics_report_slot(dev, 0, NULL);
>> -                     synaptics_report_slot(dev, 1, NULL);
>> -             } else if (mt_state->sgm == 0) {
>> -                     synaptics_report_slot(dev, 0, sgm);
>> -                     synaptics_report_slot(dev, 1, NULL);
>> -             } else {
>> -                     synaptics_report_slot(dev, 0, NULL);
>> -                     synaptics_report_slot(dev, 1, sgm);
>> -             }
>> -             break;
>> -     default:
>> -             /*
>> -              * If the finger slot contained in SGM is valid, and either
>> -              * hasn't changed, or is new, or the old SGM has now moved to
>> -              * AGM, then report SGM in MTB slot 0.
>> -              * Otherwise, empty MTB slot 0.
>> -              */
>> -             if (mt_state->sgm != -1 &&
>> -                 (mt_state->sgm == old->sgm ||
>> -                  old->sgm == -1 || mt_state->agm == old->sgm))
>> -                     synaptics_report_slot(dev, 0, sgm);
>> -             else
>> -                     synaptics_report_slot(dev, 0, NULL);
>> +     nsemi = clamp_val(num_fingers, 0, 2);
>>
>> -             /*
>> -              * If the finger slot contained in AGM is valid, and either
>> -              * hasn't changed, or is new, then report AGM in MTB slot 1.
>> -              * Otherwise, empty MTB slot 1.
>> -              *
>> -              * However, in the case where the AGM is new, make sure that
>> -              * that it is either the same as the old SGM, or there was no
>> -              * SGM.
>> -              *
>> -              * Otherwise, if the SGM was just 1, and the new AGM is 2, then
>> -              * the new AGM will keep the old SGM's tracking ID, which can
>> -              * cause apparent drumroll.  This happens if in the following
>> -              * valid finger sequence:
>> -              *
>> -              *  Action                 SGM  AGM (MTB slot:Contact)
>> -              *  1. Touch contact 0    (0:0)
>> -              *  2. Touch contact 1    (0:0, 1:1)
>> -              *  3. Lift  contact 0    (1:1)
>> -              *  4. Touch contacts 2,3 (0:2, 1:3)
>> -              *
>> -              * In step 4, contact 3, in AGM must not be given the same
>> -              * tracking ID as contact 1 had in step 3.  To avoid this,
>> -              * the first agm with contact 3 is dropped and slot 1 is
>> -              * invalidated (tracking ID = -1).
>> -              */
>> -             if (mt_state->agm != -1 &&
>> -                 (mt_state->agm == old->agm ||
>> -                  (old->agm == -1 &&
>> -                   (old->sgm == -1 || mt_state->agm == old->sgm))))
>> -                     synaptics_report_slot(dev, 1, agm);
>> -             else
>> -                     synaptics_report_slot(dev, 1, NULL);
>> -             break;
>> +     for (i = 0; i < nsemi; i++) {
>> +             pos[i].x = hw[i]->x;
>> +             pos[i].y = synaptics_invert_y(hw[i]->y);
>>       }
>>
>> +     input_mt_assign_slots(dev, slot, pos, nsemi);
>> +
>> +     for (i = 0; i < nsemi; i++) {
>> +             input_mt_slot(dev, slot[i]);
>> +             input_mt_report_slot_state(dev, MT_TOOL_FINGER, true);
>> +             input_report_abs(dev, ABS_MT_POSITION_X, pos[i].x);
>> +             input_report_abs(dev, ABS_MT_POSITION_Y, pos[i].y);
>> +             input_report_abs(dev, ABS_MT_PRESSURE, hw[i]->z);
>> +     }
>> +
>> +     input_mt_drop_unused(dev);
>> +
>>       /* Don't use active slot count to generate BTN_TOOL events. */
>>       input_mt_report_pointer_emulation(dev, false);
>>
>>       /* Send the number of fingers reported by touchpad itself. */
>> -     input_mt_report_finger_count(dev, mt_state->count);
>> +     input_mt_report_finger_count(dev, num_fingers);
>>
>>       synaptics_report_buttons(psmouse, sgm);
>>
>>       input_sync(dev);
>>  }
>>
>> -/* Handle case where mt_state->count = 0 */
>> -static void synaptics_image_sensor_0f(struct synaptics_data *priv,
>> -                                   struct synaptics_mt_state *mt_state)
>> -{
>> -     synaptics_mt_state_set(mt_state, 0, -1, -1);
>> -     priv->mt_state_lost = false;
>> -}
>> -
>> -/* Handle case where mt_state->count = 1 */
>> -static void synaptics_image_sensor_1f(struct synaptics_data *priv,
>> -                                   struct synaptics_mt_state *mt_state)
>> -{
>> -     struct synaptics_hw_state *agm = &priv->agm;
>> -     struct synaptics_mt_state *old = &priv->mt_state;
>> -
>> -     /*
>> -      * If the last AGM was (0,0,0), and there is only one finger left,
>> -      * then we absolutely know that SGM contains slot 0, and all other
>> -      * fingers have been removed.
>> -      */
>> -     if (priv->agm_pending && agm->z == 0) {
>> -             synaptics_mt_state_set(mt_state, 1, 0, -1);
>> -             priv->mt_state_lost = false;
>> -             return;
>> -     }
>> -
>> -     switch (old->count) {
>> -     case 0:
>> -             synaptics_mt_state_set(mt_state, 1, 0, -1);
>> -             break;
>> -     case 1:
>> -             /*
>> -              * If mt_state_lost, then the previous transition was 3->1,
>> -              * and SGM now contains either slot 0 or 1, but we don't know
>> -              * which.  So, we just assume that the SGM now contains slot 1.
>> -              *
>> -              * If pending AGM and either:
>> -              *   (a) the previous SGM slot contains slot 0, or
>> -              *   (b) there was no SGM slot
>> -              * then, the SGM now contains slot 1
>> -              *
>> -              * Case (a) happens with very rapid "drum roll" gestures, where
>> -              * slot 0 finger is lifted and a new slot 1 finger touches
>> -              * within one reporting interval.
>> -              *
>> -              * Case (b) happens if initially two or more fingers tap
>> -              * briefly, and all but one lift before the end of the first
>> -              * reporting interval.
>> -              *
>> -              * (In both these cases, slot 0 will becomes empty, so SGM
>> -              * contains slot 1 with the new finger)
>> -              *
>> -              * Else, if there was no previous SGM, it now contains slot 0.
>> -              *
>> -              * Otherwise, SGM still contains the same slot.
>> -              */
>> -             if (priv->mt_state_lost ||
>> -                 (priv->agm_pending && old->sgm <= 0))
>> -                     synaptics_mt_state_set(mt_state, 1, 1, -1);
>> -             else if (old->sgm == -1)
>> -                     synaptics_mt_state_set(mt_state, 1, 0, -1);
>> -             break;
>> -     case 2:
>> -             /*
>> -              * If mt_state_lost, we don't know which finger SGM contains.
>> -              *
>> -              * So, report 1 finger, but with both slots empty.
>> -              * We will use slot 1 on subsequent 1->1
>> -              */
>> -             if (priv->mt_state_lost) {
>> -                     synaptics_mt_state_set(mt_state, 1, -1, -1);
>> -                     break;
>> -             }
>> -             /*
>> -              * Since the last AGM was NOT (0,0,0), it was the finger in
>> -              * slot 0 that has been removed.
>> -              * So, SGM now contains previous AGM's slot, and AGM is now
>> -              * empty.
>> -              */
>> -             synaptics_mt_state_set(mt_state, 1, old->agm, -1);
>> -             break;
>> -     case 3:
>> -             /*
>> -              * Since last AGM was not (0,0,0), we don't know which finger
>> -              * is left.
>> -              *
>> -              * So, report 1 finger, but with both slots empty.
>> -              * We will use slot 1 on subsequent 1->1
>> -              */
>> -             synaptics_mt_state_set(mt_state, 1, -1, -1);
>> -             priv->mt_state_lost = true;
>> -             break;
>> -     case 4:
>> -     case 5:
>> -             /* mt_state was updated by AGM-CONTACT packet */
>> -             break;
>> -     }
>> -}
>> -
>> -/* Handle case where mt_state->count = 2 */
>> -static void synaptics_image_sensor_2f(struct synaptics_data *priv,
>> -                                   struct synaptics_mt_state *mt_state)
>> -{
>> -     struct synaptics_mt_state *old = &priv->mt_state;
>> -
>> -     switch (old->count) {
>> -     case 0:
>> -             synaptics_mt_state_set(mt_state, 2, 0, 1);
>> -             break;
>> -     case 1:
>> -             /*
>> -              * If previous SGM contained slot 1 or higher, SGM now contains
>> -              * slot 0 (the newly touching finger) and AGM contains SGM's
>> -              * previous slot.
>> -              *
>> -              * Otherwise, SGM still contains slot 0 and AGM now contains
>> -              * slot 1.
>> -              */
>> -             if (old->sgm >= 1)
>> -                     synaptics_mt_state_set(mt_state, 2, 0, old->sgm);
>> -             else
>> -                     synaptics_mt_state_set(mt_state, 2, 0, 1);
>> -             break;
>> -     case 2:
>> -             /*
>> -              * If mt_state_lost, SGM now contains either finger 1 or 2, but
>> -              * we don't know which.
>> -              * So, we just assume that the SGM contains slot 0 and AGM 1.
>> -              */
>> -             if (priv->mt_state_lost)
>> -                     synaptics_mt_state_set(mt_state, 2, 0, 1);
>> -             /*
>> -              * Otherwise, use the same mt_state, since it either hasn't
>> -              * changed, or was updated by a recently received AGM-CONTACT
>> -              * packet.
>> -              */
>> -             break;
>> -     case 3:
>> -             /*
>> -              * 3->2 transitions have two unsolvable problems:
>> -              *  1) no indication is given which finger was removed
>> -              *  2) no way to tell if agm packet was for finger 3
>> -              *     before 3->2, or finger 2 after 3->2.
>> -              *
>> -              * So, report 2 fingers, but empty all slots.
>> -              * We will guess slots [0,1] on subsequent 2->2.
>> -              */
>> -             synaptics_mt_state_set(mt_state, 2, -1, -1);
>> -             priv->mt_state_lost = true;
>> -             break;
>> -     case 4:
>> -     case 5:
>> -             /* mt_state was updated by AGM-CONTACT packet */
>> -             break;
>> -     }
>> -}
>> -
>> -/* Handle case where mt_state->count = 3 */
>> -static void synaptics_image_sensor_3f(struct synaptics_data *priv,
>> -                                   struct synaptics_mt_state *mt_state)
>> -{
>> -     struct synaptics_mt_state *old = &priv->mt_state;
>> -
>> -     switch (old->count) {
>> -     case 0:
>> -             synaptics_mt_state_set(mt_state, 3, 0, 2);
>> -             break;
>> -     case 1:
>> -             /*
>> -              * If previous SGM contained slot 2 or higher, SGM now contains
>> -              * slot 0 (one of the newly touching fingers) and AGM contains
>> -              * SGM's previous slot.
>> -              *
>> -              * Otherwise, SGM now contains slot 0 and AGM contains slot 2.
>> -              */
>> -             if (old->sgm >= 2)
>> -                     synaptics_mt_state_set(mt_state, 3, 0, old->sgm);
>> -             else
>> -                     synaptics_mt_state_set(mt_state, 3, 0, 2);
>> -             break;
>> -     case 2:
>> -             /*
>> -              * If the AGM previously contained slot 3 or higher, then the
>> -              * newly touching finger is in the lowest available slot.
>> -              *
>> -              * If SGM was previously 1 or higher, then the new SGM is
>> -              * now slot 0 (with a new finger), otherwise, the new finger
>> -              * is now in a hidden slot between 0 and AGM's slot.
>> -              *
>> -              * In all such cases, the SGM now contains slot 0, and the AGM
>> -              * continues to contain the same slot as before.
>> -              */
>> -             if (old->agm >= 3) {
>> -                     synaptics_mt_state_set(mt_state, 3, 0, old->agm);
>> -                     break;
>> -             }
>> -
>> -             /*
>> -              * After some 3->1 and all 3->2 transitions, we lose track
>> -              * of which slot is reported by SGM and AGM.
>> -              *
>> -              * For 2->3 in this state, report 3 fingers, but empty all
>> -              * slots, and we will guess (0,2) on a subsequent 0->3.
>> -              *
>> -              * To userspace, the resulting transition will look like:
>> -              *    2:[0,1] -> 3:[-1,-1] -> 3:[0,2]
>> -              */
>> -             if (priv->mt_state_lost) {
>> -                     synaptics_mt_state_set(mt_state, 3, -1, -1);
>> -                     break;
>> -             }
>> -
>> -             /*
>> -              * If the (SGM,AGM) really previously contained slots (0, 1),
>> -              * then we cannot know what slot was just reported by the AGM,
>> -              * because the 2->3 transition can occur either before or after
>> -              * the AGM packet. Thus, this most recent AGM could contain
>> -              * either the same old slot 1 or the new slot 2.
>> -              * Subsequent AGMs will be reporting slot 2.
>> -              *
>> -              * To userspace, the resulting transition will look like:
>> -              *    2:[0,1] -> 3:[0,-1] -> 3:[0,2]
>> -              */
>> -             synaptics_mt_state_set(mt_state, 3, 0, -1);
>> -             break;
>> -     case 3:
>> -             /*
>> -              * If, for whatever reason, the previous agm was invalid,
>> -              * Assume SGM now contains slot 0, AGM now contains slot 2.
>> -              */
>> -             if (old->agm <= 2)
>> -                     synaptics_mt_state_set(mt_state, 3, 0, 2);
>> -             /*
>> -              * mt_state either hasn't changed, or was updated by a recently
>> -              * received AGM-CONTACT packet.
>> -              */
>> -             break;
>> -
>> -     case 4:
>> -     case 5:
>> -             /* mt_state was updated by AGM-CONTACT packet */
>> -             break;
>> -     }
>> -}
>> -
>> -/* Handle case where mt_state->count = 4, or = 5 */
>> -static void synaptics_image_sensor_45f(struct synaptics_data *priv,
>> -                                    struct synaptics_mt_state *mt_state)
>> -{
>> -     /* mt_state was updated correctly by AGM-CONTACT packet */
>> -     priv->mt_state_lost = false;
>> -}
>> -
>>  static void synaptics_image_sensor_process(struct psmouse *psmouse,
>>                                          struct synaptics_hw_state *sgm)
>>  {
>>       struct synaptics_data *priv = psmouse->private;
>> -     struct synaptics_hw_state *agm = &priv->agm;
>> -     struct synaptics_mt_state mt_state;
>> -
>> -     /* Initialize using current mt_state (as updated by last agm) */
>> -     mt_state = agm->mt_state;
>> +     int num_fingers;
>>
>>       /*
>>        * Update mt_state using the new finger count and current mt_state.
>>        */
>>       if (sgm->z == 0)
>> -             synaptics_image_sensor_0f(priv, &mt_state);
>> +             num_fingers = 0;
>>       else if (sgm->w >= 4)
>> -             synaptics_image_sensor_1f(priv, &mt_state);
>> +             num_fingers = 1;
>>       else if (sgm->w == 0)
>> -             synaptics_image_sensor_2f(priv, &mt_state);
>> -     else if (sgm->w == 1 && mt_state.count <= 3)
>> -             synaptics_image_sensor_3f(priv, &mt_state);
>> +             num_fingers = 2;
>> +     else if (sgm->w == 1)
>> +             num_fingers = priv->agm_count ? priv->agm_count : 3;
>>       else
>> -             synaptics_image_sensor_45f(priv, &mt_state);
>> +             num_fingers = 4;
>>
>>       /* Send resulting input events to user space */
>> -     synaptics_report_mt_data(psmouse, &mt_state, sgm);
>> -
>> -     /* Store updated mt_state */
>> -     priv->mt_state = agm->mt_state = mt_state;
>> -     priv->agm_pending = false;
>> +     synaptics_report_mt_data(psmouse, sgm, num_fingers);
>>  }
>>
>>  static void synaptics_profile_sensor_process(struct psmouse *psmouse,
>> @@ -1439,7 +1108,7 @@ static void set_input_params(struct psmouse *psmouse,
>>                                       ABS_MT_POSITION_Y);
>>               /* Image sensors can report per-contact pressure */
>>               input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
>> -             input_mt_init_slots(dev, 2, INPUT_MT_POINTER);
>> +             input_mt_init_slots(dev, 2, INPUT_MT_POINTER | INPUT_MT_TRACK);
>>
>>               /* Image sensors can signal 4 and 5 finger clicks */
>>               __set_bit(BTN_TOOL_QUADTAP, dev->keybit);
>> diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
>> index 1bd01f2..6faf9bb 100644
>> --- a/drivers/input/mouse/synaptics.h
>> +++ b/drivers/input/mouse/synaptics.h
>> @@ -119,16 +119,6 @@
>>  #define SYN_REDUCED_FILTER_FUZZ              8
>>
>>  /*
>> - * A structure to describe which internal touchpad finger slots are being
>> - * reported in raw packets.
>> - */
>> -struct synaptics_mt_state {
>> -     int count;                      /* num fingers being tracked */
>> -     int sgm;                        /* which slot is reported by sgm pkt */
>> -     int agm;                        /* which slot is reported by agm pkt*/
>> -};
>> -
>> -/*
>>   * A structure to describe the state of the touchpad hardware (buttons and pad)
>>   */
>>  struct synaptics_hw_state {
>> @@ -143,9 +133,6 @@ struct synaptics_hw_state {
>>       unsigned int down:1;
>>       unsigned char ext_buttons;
>>       signed char scroll;
>> -
>> -     /* As reported in last AGM-CONTACT packets */
>> -     struct synaptics_mt_state mt_state;
>>  };
>>
>>  struct synaptics_data {
>> @@ -170,15 +157,12 @@ struct synaptics_data {
>>
>>       struct serio *pt_port;                  /* Pass-through serio port */
>>
>> -     struct synaptics_mt_state mt_state;     /* Current mt finger state */
>> -     bool mt_state_lost;                     /* mt_state may be incorrect */
>> -
>>       /*
>>        * Last received Advanced Gesture Mode (AGM) packet. An AGM packet
>>        * contains position data for a second contact, at half resolution.
>>        */
>>       struct synaptics_hw_state agm;
>> -     bool agm_pending;                       /* new AGM packet received */
>> +     unsigned int agm_count;                 /* finger count reported by agm */
>>
>>       /* ForcePad handling */
>>       unsigned long                           press_start;
>> --
>> 2.1.0
>>
>
> --
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
