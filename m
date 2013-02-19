Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab3BSQ6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:58:06 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:35400 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab3BSQ6B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:58:01 -0500
MIME-Version: 1.0
In-Reply-To: <1361263001.7859.11.camel@liguang.fnst.cn.fujitsu.com>
References: <1360988172-15380-1-git-send-email-sjg@chromium.org>
	<1360988172-15380-7-git-send-email-sjg@chromium.org>
	<1361263001.7859.11.camel@liguang.fnst.cn.fujitsu.com>
Date: Tue, 19 Feb 2013 08:58:00 -0800
X-Google-Sender-Auth: WR9mZCGXmyatrLTahGO5WII2pFM
Message-ID: <CAPnjgZ1rHy5Mz_RQC7v5omwSiKPSzzA6dXcqTcfYh8PD1MshUg@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] Input: Add ChromeOS EC keyboard driver
From: Simon Glass <sjg@chromium.org>
To: li guang <lig.fnst@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Luigi Semenzato <semenzato@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Mike A. Chan" <mikechan@google.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Tom Keel <thomas.keel@intel.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 19, 2013 at 12:36 AM, li guang <lig.fnst@cn.fujitsu.com> wrote:
> 在 2013-02-15五的 20:16 -0800，Simon Glass写道：
>> Use the key-matrix layer to interpret key scan information from the EC
>> and inject input based on the FDT-supplied key map. This driver registers
>> itself with the ChromeOS EC driver to perform communications.
>
> [snip ...]
>> +/*
>> + * Returns true when there is at least one combination of pressed keys that
>> + * results in ghosting.
>> + */
>> +static bool cros_ec_keyb_has_ghosting(struct cros_ec_keyb *ckdev, uint8_t *buf)
>> +{
>> +     int row;
>> +
>> +     /*
>> +      * Ghosting happens if for any pressed key X there are other keys
>> +      * pressed both in the same row and column of X as, for instance,
>> +      * in the following diagram:
>> +      *
>> +      * . . Y . g .
>> +      * . . . . . .
>> +      * . . . . . .
>> +      * . . X . Z .
>> +      *
>> +      * In this case only X, Y, and Z are pressed, but g appears to be
>> +      * pressed too (see Wikipedia).
>> +      *
>> +      * We can detect ghosting in a single pass (*) over the keyboard state
>> +      * by maintaining two arrays.  pressed_in_row counts how many pressed
>> +      * keys we have found in a row.  row_has_teeth is true if any of the
>> +      * pressed keys for this row has other pressed keys in its column.  If
>> +      * at any point of the scan we find that a row has multiple pressed
>> +      * keys, and at least one of them is at the intersection with a column
>> +      * with multiple pressed keys, we're sure there is ghosting.
>> +      * Conversely, if there is ghosting, we will detect such situation for
>> +      * at least one key during the pass.
>> +      *
>> +      * (*) This looks linear in the number of keys, but it's not.  We can
>> +      * cheat because the number of rows is small.
>> +      */
>> +     for (row = 0; row < ckdev->rows; row++) {
>> +             if (cros_ec_keyb_row_has_ghosting(ckdev, buf, row))
>> +                     return true;
>> +     }
>> +
>> +     return false;
>> +}
>
> are you sure your EC's firmware did not do ghost-key detection?
> or, did you test ghost-key with/without your own ghost-key detection?
> as far as I know, ghost-key should be take care either by keyboard
> designer or firmware.
>

Yes, the matrix scans are sent from the EC in a raw form - in fact the
EC on snow does not even know the keycode map. The EC does handle
debouncing though. The idea is to reduce code/complexity in the EC
where we are space-constrained.

[snip]

Regards,
Simon
