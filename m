Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaLCQmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:42:07 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:62160 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaLCQmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:42:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAJAp7OjrC_huXY268XFrE+v63bWW7r8JW6XpcKPYLfvqzOjcMg@mail.gmail.com>
References: <1417470961-16524-1-git-send-email-jilaiw@codeaurora.org>
	<CAJAp7OjrC_huXY268XFrE+v63bWW7r8JW6XpcKPYLfvqzOjcMg@mail.gmail.com>
Date: Wed, 3 Dec 2014 11:42:03 -0500
Message-ID: <CAF6AEGts4791fkM4NzYWyGhx4HvoBUDtqsRNgjB5k=6bUOA2LA@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/msm/hdmi: add hdmi hdcp support
From: Rob Clark <robdclark@gmail.com>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Jilai Wang <jilaiw@codeaurora.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 8:46 PM, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Mon, Dec 1, 2014 at 1:56 PM, Jilai Wang <jilaiw@codeaurora.org> wrote:
>> Add HDMI HDCP support including HDCP PartI/II/III authentication.
>>
>> Signed-off-by: Jilai Wang <jilaiw@codeaurora.org>
>> ---
>
> Hi Jilai,
>
> [..]
>
>> diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
>
> [..]
>
>>
>> @@ -119,6 +137,22 @@ struct hdmi *hdmi_init(struct drm_device *dev, struct drm_encoder *encoder)
>>                 goto fail;
>>         }
>>
>> +       /* HDCP needs physical address of hdmi register */
>> +       res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>> +               config->mmio_name);
>
> Is this guaranteed to be available at all times? You should probably
> do some error handling here.

Hi Bjorn,

(as mentioned on irc, but just repeating here for posterity)

this is actually ok in this case, since the previous ioremap would have failed.

>> +       hdmi->mmio_phy_addr = res->start;
>> +
>> +       if (config->qfprom_mmio_name) {
>
> Should this check really be here? This will always be set if CONFIG_OF is set
> and never otherwise and that seems strange to me.
>
> Perhaps you should add the string to the !CONFIG_OF platforms as well or simply
> add #ifdef CONFIG_OF around this section if that's what you really want. (but
> seems more like you forgot the non-of case).

or just not cared enough to make HDCP (since it is optional) work on
old pre-DT vendor kernel ;-)

fwiw, eventually the !CONFIG_OF stuff will go away.. it just exists
because some devices and some use-cases still need old downstream
kernels :-(

>> +               hdmi->qfprom_mmio = msm_ioremap(pdev,
>> +                       config->qfprom_mmio_name, "HDMI_QFPROM");
>
>
> Is this a special hdmi qfprom or are you ioremapping _the_ qfprom here?
>
> If so I did suggest that we expose it as a syscon but I think Stephen Boyd had
> some other ideas.

afaict (but Jilai can correct me), it is *the* qfprom.. that seems to
be how things worked in android kernels.  Some better mechanism would
be really nice.

>> +               if (IS_ERR(hdmi->qfprom_mmio)) {
>> +                       dev_info(&pdev->dev, "can't find qfprom resource\n");
>> +                       hdmi->qfprom_mmio = NULL;
>> +               }
>> +       } else {
>> +               hdmi->qfprom_mmio = NULL;
>
> hdmi_qfprom_read() seems to be called and read from qfprom_mmio no matter how
> this ended. Are you sure this (both error paths) shouldn't be handled as a
> fatal error?

hdmi_hdcp_init() fails (and then we continue without HDCP) if
qfprom_mmio is NULL..

> 'hdmi' is kzalloc and hence already NULL.
>
> [..]
>
>> @@ -205,6 +241,13 @@ struct hdmi *hdmi_init(struct drm_device *dev, struct drm_encoder *encoder)
>>                 goto fail;
>>         }
>>
>> +       hdmi->hdcp_ctrl = hdmi_hdcp_init(hdmi);
>> +       if (IS_ERR(hdmi->hdcp_ctrl)) {
>> +               ret = PTR_ERR(hdmi->hdcp_ctrl);
>> +               dev_warn(dev->dev, "failed to init hdcp: %d(disabled)\n", ret);
>> +               hdmi->hdcp_ctrl = NULL;
>
> So either you treat this as an error or you don't.
>
> If you're fine continuing execution without hdcp_ctrl then you shouldn't set
> ret. But in that case it you should probably not print a warning every time you
> enter hdmi_hdcp_on() and an error on hdmi_hdcp_off().

agreed, I think it would be better for hdcp_on/off() to take struct
hdmi_hdcp_ctrl as param (and just not be called if hdmi->hdcp_ctrl is
null)

[snip]

> [..]
>
>> +
>> +struct hdmi_hdcp_reg_data {
>> +       uint32_t reg_id;
>
> You should use u32 instead of uint32_t in the kernel.

tbh, I'd prefer sticking to stdint types..  before stdint was a thing,
u32 made sense

>> +       uint32_t off;
>> +       char *name;
>> +       uint32_t reg_val;
>> +};
>> +
>> +struct hdmi_hdcp_ctrl {
>> +       struct hdmi *hdmi;
>> +       uint32_t auth_retries;
>> +       uint32_t tz_hdcp;
>
> Turn this into a bool named something like has_tz_hdcp instead, as that's what
> it really means.
>
>> +       enum hdmi_hdcp_state hdcp_state;
>> +       struct mutex state_mutex;
>> +       struct delayed_work hdcp_reauth_work;
>> +       struct delayed_work hdcp_auth_part1_1_work;
>> +       struct delayed_work hdcp_auth_part1_2_work;
>> +       struct work_struct hdcp_auth_part1_3_work;
>> +       struct delayed_work hdcp_auth_part2_1_work;
>> +       struct delayed_work hdcp_auth_part2_2_work;
>> +       struct delayed_work hdcp_auth_part2_3_work;
>> +       struct delayed_work hdcp_auth_part2_4_work;
>> +       struct work_struct hdcp_auth_prepare_work;
>
> You shouldn't use "work" as a way to express states in your state machine.
> Better have 1 auth work function that does all these steps, probably having
> them split in functions just like you do now.
>
> That way you can have 1 function running the pass of authentication, starting
> by checking if you're reauthing or not then processing each step one by one,
> sleeping inbetween them. You can have the functions return -EAGAIN to indicate
> that you need to retry the current operation and so on.
>
> This would split the state machine from the state executioners and simplify
> your code.

As a side note (disclaimer, I'm not an hdcp expert), but I wonder if
eventually some of that should be extracted out into some helpers in
drm core.  I guess that is something we'll figure out when a 2nd
driver gains upstream HDCP support.  One big work w/ msleep()'s does
sound like it would be easier to understand (and therefore easier to
refactor out into helpers).

[snip]

>> +
>> +static int hdmi_hdcp_scm_wr(struct hdmi_hdcp_ctrl *hdcp_ctrl, uint32_t *preg,
>> +       uint32_t *pdata, uint32_t count)
>> +{
>> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
>> +       struct scm_hdcp_req scm_buf[SCM_HDCP_MAX_REG];
>> +       uint32_t resp, phy_addr, idx = 0;
>> +       int i, ret = 0;
>> +
>> +       if (count == 0)
>> +               return 0;
>
> There are no calls to this function where count can be 0, so you can drop this
> check.
>
>> +
>> +       if (!preg || !pdata) {
>> +               pr_err("%s: Invalid pointer\n", __func__);
>> +               return -EINVAL;
>> +       }
>
> There are no calls to this function where either of these are NULL, so you can
> drop the entire block.

or just WARN_ON() (for both this and the count).. I find that makes
the constraints more clear for someone coming along later and mucking
with that code

>
>> +
>> +       if (hdcp_ctrl->tz_hdcp) {
>> +               phy_addr = (uint32_t)hdmi->mmio_phy_addr;
>> +
>> +               while (count) {
>> +                       memset(scm_buf, 0, sizeof(scm_buf));
>> +                       for (i = 0; i < count && i < SCM_HDCP_MAX_REG; i++) {
>> +                               scm_buf[i].addr = phy_addr + preg[idx];
>> +                               scm_buf[i].val  = pdata[idx];
>> +                               idx++;
>> +                       }
>> +                       ret = scm_call(SCM_SVC_HDCP, SCM_CMD_HDCP,
>> +                               scm_buf, sizeof(scm_buf), &resp, sizeof(resp));
>
> SCM_SVC_HDCP nor SCM_CMD_HDCP are defined, here. See the comment above related
> to TZ_HDCP_CMD_ID.
>
>> +
>> +                       if (ret || resp) {
>> +                               pr_err("%s: error: scm_call ret = %d, resp = %d\n",
>> +                                       __func__, ret, resp);
>> +                               ret = -EINVAL;
>> +                               break;
>> +                       }
>> +
>> +                       count -= i;
>> +               }
>> +       } else {
>> +               for (i = 0; i < count; i++)
>> +                       hdmi_write(hdmi, preg[i], pdata[i]);
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>> +void hdmi_hdcp_irq(struct hdmi_hdcp_ctrl *hdcp_ctrl)
>> +{
>> +       struct hdmi *hdmi;
>> +       uint32_t regval, hdcp_int_status;
>> +       unsigned long flags;
>> +
>> +       if (!hdcp_ctrl) {
>> +               DBG("HDCP is disabled");
>> +               return;
>> +       }
>
> No need to print a debug line here every time.
>
> I would have preferred if you made the call from hdmi_irq() conditional
> instead, then you would need to check here...

me too

[snip]

>> +static void reset_hdcp_ddc_failures(struct hdmi_hdcp_ctrl *hdcp_ctrl)
>> +{
>> +       int hdcp_ddc_ctrl1_reg;
>> +       int hdcp_ddc_status;
>> +       int failure;
>> +       int nack0;
>> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
>> +
>> +       /* Check for any DDC transfer failures */
>> +       hdcp_ddc_status = hdmi_read(hdmi, REG_HDMI_HDCP_DDC_STATUS);
>> +       failure = (hdcp_ddc_status >> 16) & 0x1;
>
> failure = hdcp_ddc_status & BIT(16);
>
>> +       nack0 = (hdcp_ddc_status >> 14) & 0x1;
>
> nack0 = hdcp_ddc_status & BIT(14);
>
>> +       DBG("On Entry: HDCP_DDC_STATUS=0x%x, FAIL=%d, NACK0=%d",
>> +               hdcp_ddc_status, failure, nack0);
>> +
>> +       if (failure == 0x1) {
>> +               /*
>> +                * Indicates that the last HDCP HW DDC transfer failed.
>> +                * This occurs when a transfer is attempted with HDCP DDC
>> +                * disabled (HDCP_DDC_DISABLE=1) or the number of retries
>> +                * matches HDCP_DDC_RETRY_CNT.
>> +                * Failure occurred,  let's clear it.
>> +                */
>> +               DBG("DDC failure detected.HDCP_DDC_STATUS=0x%08x",
>> +                       hdcp_ddc_status);
>> +
>> +               /* First, Disable DDC */
>> +               hdmi_write(hdmi, REG_HDMI_HDCP_DDC_CTRL_0, BIT(0));
>> +
>> +               /* ACK the Failure to Clear it */
>> +               hdcp_ddc_ctrl1_reg = hdmi_read(hdmi, REG_HDMI_HDCP_DDC_CTRL_1);
>> +               hdmi_write(hdmi, REG_HDMI_HDCP_DDC_CTRL_1,
>> +                       hdcp_ddc_ctrl1_reg | BIT(0));
>> +
>> +               /* Check if the FAILURE got Cleared */
>> +               hdcp_ddc_status = hdmi_read(hdmi, REG_HDMI_HDCP_DDC_STATUS);
>
> Replace the following lines with:
>
> if (hdcp_ddc_status & BIT(16))
> pr_info("%s: Unable to clear HDCP DDC Failure\n", __func__);
>
> No need to print the debug statement either...
>
>> +               hdcp_ddc_status = (hdcp_ddc_status >> 16) & BIT(0);
>> +               if (hdcp_ddc_status == 0x0)
>> +                       DBG("HDCP DDC Failure cleared");
>> +               else
>> +                       pr_info("%s: Unable to clear HDCP DDC Failure\n",
>> +                               __func__);
>> +
>> +               /* Re-Enable HDCP DDC */
>> +               hdmi_write(hdmi, REG_HDMI_HDCP_DDC_CTRL_0, 0);
>> +       }
>> +
>> +       if (nack0 == 0x1) {
>> +               DBG("Before: HDMI_DDC_SW_STATUS=0x%08x",
>> +                       hdmi_read(hdmi, REG_HDMI_DDC_SW_STATUS));
>> +               /* Reset HDMI DDC software status */
>> +               hdmi_write(hdmi, REG_HDMI_DDC_CTRL,
>> +                       hdmi_read(hdmi, REG_HDMI_DDC_CTRL) | BIT(3));
>
> Split all these in:
> val = hdmi_read()
> val |= foo
> hdmi_write(val);
>
> To make this readable.
>
>> +               msleep(20);
>> +               hdmi_write(hdmi, REG_HDMI_DDC_CTRL,
>> +                       hdmi_read(hdmi, REG_HDMI_DDC_CTRL) & ~(BIT(3)));
>> +
>> +               /* Reset HDMI DDC Controller */
>> +               hdmi_write(hdmi, REG_HDMI_DDC_CTRL,
>> +                       hdmi_read(hdmi, REG_HDMI_DDC_CTRL) | BIT(1));
>> +               msleep(20);
>> +               hdmi_write(hdmi, REG_HDMI_DDC_CTRL,
>> +                       hdmi_read(hdmi, REG_HDMI_DDC_CTRL) & ~BIT(1));
>> +               DBG("After: HDMI_DDC_SW_STATUS=0x%08x",
>> +                       hdmi_read(hdmi, REG_HDMI_DDC_SW_STATUS));
>> +       }
>> +
>
> Just end the function here, no need for the extra debug printouts...
>
>> +       hdcp_ddc_status = hdmi_read(hdmi, REG_HDMI_HDCP_DDC_STATUS);
>> +
>> +       failure = (hdcp_ddc_status >> 16) & BIT(0);
>> +       nack0 = (hdcp_ddc_status >> 14) & BIT(0);
>> +       DBG("On Exit: HDCP_DDC_STATUS=0x%x, FAIL=%d, NACK0=%d",
>> +               hdcp_ddc_status, failure, nack0);
>> +}

DBG() stuff can always be enabled at runtime.. and when it comes to
failures seen with certain monitors, it is usually the monitor the
user has and not the ones the developer has, which have fun bugs ;-)

So in general if it is something useful for debugging a failure, when
you can just ask the user to 'echo 15 >
/sys/modules/drm/parameters/debug' then plug in monitor and send
dmesg, I don't mind keeping it.

BR,
-R
