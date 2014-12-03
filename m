Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaLCBqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:46:10 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:48755 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaLCBqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:46:07 -0500
MIME-Version: 1.0
In-Reply-To: <1417470961-16524-1-git-send-email-jilaiw@codeaurora.org>
References: <1417470961-16524-1-git-send-email-jilaiw@codeaurora.org>
Date: Tue, 2 Dec 2014 17:46:04 -0800
Message-ID: <CAJAp7OjrC_huXY268XFrE+v63bWW7r8JW6XpcKPYLfvqzOjcMg@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/msm/hdmi: add hdmi hdcp support
From: Bjorn Andersson <bjorn@kryo.se>
To: Jilai Wang <jilaiw@codeaurora.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 1:56 PM, Jilai Wang <jilaiw@codeaurora.org> wrote:
> Add HDMI HDCP support including HDCP PartI/II/III authentication.
>
> Signed-off-by: Jilai Wang <jilaiw@codeaurora.org>
> ---

Hi Jilai,

[..]

> diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c

[..]

>
> @@ -119,6 +137,22 @@ struct hdmi *hdmi_init(struct drm_device *dev, struct drm_encoder *encoder)
>                 goto fail;
>         }
>
> +       /* HDCP needs physical address of hdmi register */
> +       res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +               config->mmio_name);

Is this guaranteed to be available at all times? You should probably
do some error handling here.

> +       hdmi->mmio_phy_addr = res->start;
> +
> +       if (config->qfprom_mmio_name) {

Should this check really be here? This will always be set if CONFIG_OF is set
and never otherwise and that seems strange to me.

Perhaps you should add the string to the !CONFIG_OF platforms as well or simply
add #ifdef CONFIG_OF around this section if that's what you really want. (but
seems more like you forgot the non-of case).

> +               hdmi->qfprom_mmio = msm_ioremap(pdev,
> +                       config->qfprom_mmio_name, "HDMI_QFPROM");


Is this a special hdmi qfprom or are you ioremapping _the_ qfprom here?

If so I did suggest that we expose it as a syscon but I think Stephen Boyd had
some other ideas.

> +               if (IS_ERR(hdmi->qfprom_mmio)) {
> +                       dev_info(&pdev->dev, "can't find qfprom resource\n");
> +                       hdmi->qfprom_mmio = NULL;
> +               }
> +       } else {
> +               hdmi->qfprom_mmio = NULL;

hdmi_qfprom_read() seems to be called and read from qfprom_mmio no matter how
this ended. Are you sure this (both error paths) shouldn't be handled as a
fatal error?

'hdmi' is kzalloc and hence already NULL.

[..]

> @@ -205,6 +241,13 @@ struct hdmi *hdmi_init(struct drm_device *dev, struct drm_encoder *encoder)
>                 goto fail;
>         }
>
> +       hdmi->hdcp_ctrl = hdmi_hdcp_init(hdmi);
> +       if (IS_ERR(hdmi->hdcp_ctrl)) {
> +               ret = PTR_ERR(hdmi->hdcp_ctrl);
> +               dev_warn(dev->dev, "failed to init hdcp: %d(disabled)\n", ret);
> +               hdmi->hdcp_ctrl = NULL;

So either you treat this as an error or you don't.

If you're fine continuing execution without hdcp_ctrl then you shouldn't set
ret. But in that case it you should probably not print a warning every time you
enter hdmi_hdcp_on() and an error on hdmi_hdcp_off().

[..]

> diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.h b/drivers/gpu/drm/msm/hdmi/hdmi.h

[..]

> @@ -70,12 +74,25 @@ struct hdmi {
>         bool hdmi_mode;               /* are we in hdmi mode? */
>
>         int irq;
> +       struct workqueue_struct *workq;

Do you really need a special workqueue for this, can't you use the system work
queue (or system_long_wq)?

[..]

>
> +static inline u32 hdmi_qfprom_read(struct hdmi *hdmi, u32 reg)
> +{
> +       return msm_readl(hdmi->qfprom_mmio + reg);

As stated above, qfprom_mmio might be NULL.

> +}
> +

[..]

> diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_hdcp.c b/drivers/gpu/drm/msm/hdmi/hdmi_hdcp.c

[..]

> +
> +#define TZ_HDCP_CMD_ID 0x00004401

Add a definition of SCM_SVC_HDCP being 17 to scm.h and define SCM_CMD_HDCP to 1
here instead.

[..]

> +
> +struct hdmi_hdcp_reg_data {
> +       uint32_t reg_id;

You should use u32 instead of uint32_t in the kernel.

> +       uint32_t off;
> +       char *name;
> +       uint32_t reg_val;
> +};
> +
> +struct hdmi_hdcp_ctrl {
> +       struct hdmi *hdmi;
> +       uint32_t auth_retries;
> +       uint32_t tz_hdcp;

Turn this into a bool named something like has_tz_hdcp instead, as that's what
it really means.

> +       enum hdmi_hdcp_state hdcp_state;
> +       struct mutex state_mutex;
> +       struct delayed_work hdcp_reauth_work;
> +       struct delayed_work hdcp_auth_part1_1_work;
> +       struct delayed_work hdcp_auth_part1_2_work;
> +       struct work_struct hdcp_auth_part1_3_work;
> +       struct delayed_work hdcp_auth_part2_1_work;
> +       struct delayed_work hdcp_auth_part2_2_work;
> +       struct delayed_work hdcp_auth_part2_3_work;
> +       struct delayed_work hdcp_auth_part2_4_work;
> +       struct work_struct hdcp_auth_prepare_work;

You shouldn't use "work" as a way to express states in your state machine.
Better have 1 auth work function that does all these steps, probably having
them split in functions just like you do now.

That way you can have 1 function running the pass of authentication, starting
by checking if you're reauthing or not then processing each step one by one,
sleeping inbetween them. You can have the functions return -EAGAIN to indicate
that you need to retry the current operation and so on.

This would split the state machine from the state executioners and simplify
your code.

> +       uint32_t work_retry_cnt;
> +       uint32_t ksv_fifo_w_index;
> +
> +       /*
> +        * store aksv from qfprom
> +        */
> +       uint8_t aksv[5];

You should use u8 intead of uint8_t in the kernel.

> +       bool aksv_valid;
> +       uint32_t ds_type;
> +       uint8_t bksv[5];
> +       uint8_t dev_count;
> +       uint8_t depth;
> +       uint8_t ksv_list[5 * 127];
> +       bool max_cascade_exceeded;
> +       bool max_dev_exceeded;
> +};
> +
> +static int hdmi_ddc_read(struct hdmi *hdmi, uint16_t addr, uint8_t offset,
> +       uint8_t *data, uint16_t data_len, bool no_align)
> +{

As far as I can see you can replace this entire function with:

return i2c_smbus_read_i2c_block_data(hdmi->i2c, addr + offset, data_len, data);

Although note that it would return data_len instead of 0 on success.

> +       int rc = 0;
> +       int retry = 5;
> +       uint8_t *buf = NULL;
> +       uint32_t request_len;
> +       struct i2c_msg msgs[] = {
> +               {
> +                       .addr   = addr >> 1,
> +                       .flags  = 0,
> +                       .len    = 1,
> +                       .buf    = &offset,
> +               }, {
> +                       .addr   = addr >> 1,
> +                       .flags  = I2C_M_RD,
> +                       .len    = data_len,
> +                       .buf    = data,
> +               }
> +       };
> +
> +       DBG("Start DDC read");
> +retry:
> +       if (no_align) {
> +               rc = i2c_transfer(hdmi->i2c, msgs, 2);
> +       } else {
> +               request_len = 32 * ((data_len + 31) / 32);

Why are you doing this. The documentation for i2c_msg states that if you set
I2C_M_RECV_LEN you have to be able to do something like this, but you don't.

I don't see anything special with the buffers you're reading into, so you
should be able to just use i2c_smbus_read_i2c_block_data() and be done with it.

> +               buf = kmalloc(request_len, GFP_KERNEL);
> +               if (!buf)
> +                       return -ENOMEM;
> +
> +               msgs[1].buf = buf;
> +               rc = i2c_transfer(hdmi->i2c, msgs, 2);
> +       }
> +
> +       retry--;
> +       if (rc == 2) {
> +               rc = 0;
> +               if (!no_align)
> +                       memcpy(data, buf, data_len);
> +       } else if (retry > 0) {
> +               goto retry;
> +       } else {
> +               rc = -EIO;
> +       }
> +
> +       kfree(buf);
> +       DBG("End DDC read %d", rc);
> +
> +       return rc;
> +}
> +
> +static int hdmi_ddc_write(struct hdmi *hdmi, uint16_t addr, uint8_t offset,
> +       uint8_t *data, uint16_t data_len)
> +{

And as for hdmi_ddc_read, this would be:

i2c_smbus_write_i2c_block_data(hdmi->i2c, addr + offset, data_len, data);

> +       int rc = 0;
> +       int retry = 10;
> +       uint8_t *buf = NULL;
> +       struct i2c_msg msgs[] = {
> +               {
> +                       .addr   = addr >> 1,
> +                       .flags  = 0,
> +                       .len    = 1,
> +               }
> +       };
> +
> +       DBG("Start DDC write");
> +       buf = kmalloc(data_len + 1, GFP_KERNEL);
> +       if (!buf)
> +               return -ENOMEM;
> +
> +       buf[0] = offset;
> +       memcpy(&buf[1], data, data_len);
> +       msgs[0].buf = buf;
> +       msgs[0].len = data_len + 1;
> +retry:
> +       rc = i2c_transfer(hdmi->i2c, msgs, 1);
> +
> +       retry--;
> +       if (rc == 1)
> +               rc = 0;
> +       else if (retry > 0)
> +               goto retry;
> +       else
> +               rc = -EIO;
> +
> +       kfree(buf);
> +       DBG("End DDC write %d", rc);
> +
> +       return rc;
> +}
> +
> +static int hdmi_hdcp_scm_wr(struct hdmi_hdcp_ctrl *hdcp_ctrl, uint32_t *preg,
> +       uint32_t *pdata, uint32_t count)
> +{
> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
> +       struct scm_hdcp_req scm_buf[SCM_HDCP_MAX_REG];
> +       uint32_t resp, phy_addr, idx = 0;
> +       int i, ret = 0;
> +
> +       if (count == 0)
> +               return 0;

There are no calls to this function where count can be 0, so you can drop this
check.

> +
> +       if (!preg || !pdata) {
> +               pr_err("%s: Invalid pointer\n", __func__);
> +               return -EINVAL;
> +       }

There are no calls to this function where either of these are NULL, so you can
drop the entire block.

> +
> +       if (hdcp_ctrl->tz_hdcp) {
> +               phy_addr = (uint32_t)hdmi->mmio_phy_addr;
> +
> +               while (count) {
> +                       memset(scm_buf, 0, sizeof(scm_buf));
> +                       for (i = 0; i < count && i < SCM_HDCP_MAX_REG; i++) {
> +                               scm_buf[i].addr = phy_addr + preg[idx];
> +                               scm_buf[i].val  = pdata[idx];
> +                               idx++;
> +                       }
> +                       ret = scm_call(SCM_SVC_HDCP, SCM_CMD_HDCP,
> +                               scm_buf, sizeof(scm_buf), &resp, sizeof(resp));

SCM_SVC_HDCP nor SCM_CMD_HDCP are defined, here. See the comment above related
to TZ_HDCP_CMD_ID.

> +
> +                       if (ret || resp) {
> +                               pr_err("%s: error: scm_call ret = %d, resp = %d\n",
> +                                       __func__, ret, resp);
> +                               ret = -EINVAL;
> +                               break;
> +                       }
> +
> +                       count -= i;
> +               }
> +       } else {
> +               for (i = 0; i < count; i++)
> +                       hdmi_write(hdmi, preg[i], pdata[i]);
> +       }
> +
> +       return ret;
> +}
> +
> +void hdmi_hdcp_irq(struct hdmi_hdcp_ctrl *hdcp_ctrl)
> +{
> +       struct hdmi *hdmi;
> +       uint32_t regval, hdcp_int_status;
> +       unsigned long flags;
> +
> +       if (!hdcp_ctrl) {
> +               DBG("HDCP is disabled");
> +               return;
> +       }

No need to print a debug line here every time.

I would have preferred if you made the call from hdmi_irq() conditional
instead, then you would need to check here...

> +
> +       hdmi = hdcp_ctrl->hdmi;

And you could have folded this into the declaration above.

> +       spin_lock_irqsave(&hdmi->reg_lock, flags);
> +       regval = hdmi_read(hdmi, REG_HDMI_HDCP_INT_CTRL);
> +       hdcp_int_status = regval & HDCP_INT_STATUS;
> +       if (!hdcp_int_status) {
> +               spin_unlock_irqrestore(&hdmi->reg_lock, flags);
> +               return;
> +       }
> +       /* Clear Interrupts */
> +       regval |= hdcp_int_status << 1;
> +       /* Clear AUTH_FAIL_INFO as well */
> +       if (hdcp_int_status & BIT(4))
> +               regval |= BIT(7);
> +       hdmi_write(hdmi, REG_HDMI_HDCP_INT_CTRL, regval);
> +       spin_unlock_irqrestore(&hdmi->reg_lock, flags);
> +
> +       DBG("hdcp irq %x", regval);
> +       if (hdcp_int_status & BIT(0)) {
> +               /* AUTH_SUCCESS_INT */
> +               pr_info("%s:AUTH_SUCCESS_INT received\n", __func__);
> +               if (HDCP_STATE_AUTHENTICATING == hdcp_ctrl->hdcp_state)
> +                       queue_work(hdmi->workq,
> +                               &hdcp_ctrl->hdcp_auth_part1_3_work);
> +       }
> +
> +       if (hdcp_int_status & BIT(4)) {
> +               /* AUTH_FAIL_INT */
> +               regval = hdmi_read(hdmi, REG_HDMI_HDCP_LINK0_STATUS);
> +               pr_info("%s: AUTH_FAIL_INT rcvd, LINK0_STATUS=0x%08x\n",
> +                       __func__, regval);
> +               if (HDCP_STATE_AUTHENTICATED == hdcp_ctrl->hdcp_state)
> +                       queue_delayed_work(hdmi->workq,
> +                               &hdcp_ctrl->hdcp_reauth_work, HZ/2);
> +               else if (HDCP_STATE_AUTHENTICATING == hdcp_ctrl->hdcp_state)
> +                       queue_work(hdmi->workq,
> +                               &hdcp_ctrl->hdcp_auth_part1_3_work);
> +       }
> +
> +       if (hdcp_int_status & BIT(8)) {
> +               /* DDC_XFER_REQ_INT */
> +               pr_info("%s:DDC_XFER_REQ_INT received\n", __func__);
> +       }
> +
> +       if (hdcp_int_status & BIT(12)) {
> +               /* DDC_XFER_DONE_INT */
> +               pr_info("%s:DDC_XFER_DONE received\n", __func__);
> +       }

You should drop the pr_info's here, as they add don't do really do anything.

> +} /* hdmi_hdcp_isr */

Drop the comment.

> +
> +static int hdmi_hdcp_count_one(uint8_t *array, uint8_t len)
> +{

If you can get your buffer into two u32's you can use hweight32 to do this
instead.

> +       int i, j, count = 0;
> +
> +       for (i = 0; i < len; i++)
> +               for (j = 0; j < 8; j++)
> +                       count += (((array[i] >> j) & 0x1) ? 1 : 0);
> +
> +       return count;
> +}
> +
> +static int hdmi_hdcp_read_validate_aksv(struct hdmi_hdcp_ctrl *hdcp_ctrl)
> +{
> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
> +       uint32_t qfprom_aksv_lsb, qfprom_aksv_msb;
> +
> +       /* Fetch aksv from QFPROM, this info should be public. */
> +       qfprom_aksv_lsb = hdmi_qfprom_read(hdmi, HDCP_KSV_LSB);
> +       qfprom_aksv_msb = hdmi_qfprom_read(hdmi, HDCP_KSV_MSB);
> +
> +       hdcp_ctrl->aksv[0] =  qfprom_aksv_lsb        & 0xFF;
> +       hdcp_ctrl->aksv[1] = (qfprom_aksv_lsb >> 8)  & 0xFF;
> +       hdcp_ctrl->aksv[2] = (qfprom_aksv_lsb >> 16) & 0xFF;
> +       hdcp_ctrl->aksv[3] = (qfprom_aksv_lsb >> 24) & 0xFF;
> +       hdcp_ctrl->aksv[4] =  qfprom_aksv_msb        & 0xFF;

The only time you use these are in hdmi_hdcp_auth_prepare_work() where you
reverse this operation to get them back into two u32's of lsb and msb. Better
just store them as such then.

> +
> +       /* check there are 20 ones in AKSV */
> +       if (hdmi_hdcp_count_one(hdcp_ctrl->aksv, 5) != 20) {

And you can do hweight32(msb) + hweight32(lsb) != 20 here.

> +               pr_err("%s: AKSV QFPROM doesn't have 20 1's, 20 0's\n",
> +                       __func__);
> +               pr_err("%s: QFPROM AKSV chk failed (AKSV=%02x%08x)\n",
> +                       __func__, qfprom_aksv_msb,
> +                       qfprom_aksv_lsb);
> +               return -EINVAL;
> +       }
> +       DBG("AKSV=%02x%08x", qfprom_aksv_msb, qfprom_aksv_lsb);
> +
> +       return 0;
> +}
> +
> +static void reset_hdcp_ddc_failures(struct hdmi_hdcp_ctrl *hdcp_ctrl)
> +{
> +       int hdcp_ddc_ctrl1_reg;
> +       int hdcp_ddc_status;
> +       int failure;
> +       int nack0;
> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
> +
> +       /* Check for any DDC transfer failures */
> +       hdcp_ddc_status = hdmi_read(hdmi, REG_HDMI_HDCP_DDC_STATUS);
> +       failure = (hdcp_ddc_status >> 16) & 0x1;

failure = hdcp_ddc_status & BIT(16);

> +       nack0 = (hdcp_ddc_status >> 14) & 0x1;

nack0 = hdcp_ddc_status & BIT(14);

> +       DBG("On Entry: HDCP_DDC_STATUS=0x%x, FAIL=%d, NACK0=%d",
> +               hdcp_ddc_status, failure, nack0);
> +
> +       if (failure == 0x1) {
> +               /*
> +                * Indicates that the last HDCP HW DDC transfer failed.
> +                * This occurs when a transfer is attempted with HDCP DDC
> +                * disabled (HDCP_DDC_DISABLE=1) or the number of retries
> +                * matches HDCP_DDC_RETRY_CNT.
> +                * Failure occurred,  let's clear it.
> +                */
> +               DBG("DDC failure detected.HDCP_DDC_STATUS=0x%08x",
> +                       hdcp_ddc_status);
> +
> +               /* First, Disable DDC */
> +               hdmi_write(hdmi, REG_HDMI_HDCP_DDC_CTRL_0, BIT(0));
> +
> +               /* ACK the Failure to Clear it */
> +               hdcp_ddc_ctrl1_reg = hdmi_read(hdmi, REG_HDMI_HDCP_DDC_CTRL_1);
> +               hdmi_write(hdmi, REG_HDMI_HDCP_DDC_CTRL_1,
> +                       hdcp_ddc_ctrl1_reg | BIT(0));
> +
> +               /* Check if the FAILURE got Cleared */
> +               hdcp_ddc_status = hdmi_read(hdmi, REG_HDMI_HDCP_DDC_STATUS);

Replace the following lines with:

if (hdcp_ddc_status & BIT(16))
pr_info("%s: Unable to clear HDCP DDC Failure\n", __func__);

No need to print the debug statement either...

> +               hdcp_ddc_status = (hdcp_ddc_status >> 16) & BIT(0);
> +               if (hdcp_ddc_status == 0x0)
> +                       DBG("HDCP DDC Failure cleared");
> +               else
> +                       pr_info("%s: Unable to clear HDCP DDC Failure\n",
> +                               __func__);
> +
> +               /* Re-Enable HDCP DDC */
> +               hdmi_write(hdmi, REG_HDMI_HDCP_DDC_CTRL_0, 0);
> +       }
> +
> +       if (nack0 == 0x1) {
> +               DBG("Before: HDMI_DDC_SW_STATUS=0x%08x",
> +                       hdmi_read(hdmi, REG_HDMI_DDC_SW_STATUS));
> +               /* Reset HDMI DDC software status */
> +               hdmi_write(hdmi, REG_HDMI_DDC_CTRL,
> +                       hdmi_read(hdmi, REG_HDMI_DDC_CTRL) | BIT(3));

Split all these in:
val = hdmi_read()
val |= foo
hdmi_write(val);

To make this readable.

> +               msleep(20);
> +               hdmi_write(hdmi, REG_HDMI_DDC_CTRL,
> +                       hdmi_read(hdmi, REG_HDMI_DDC_CTRL) & ~(BIT(3)));
> +
> +               /* Reset HDMI DDC Controller */
> +               hdmi_write(hdmi, REG_HDMI_DDC_CTRL,
> +                       hdmi_read(hdmi, REG_HDMI_DDC_CTRL) | BIT(1));
> +               msleep(20);
> +               hdmi_write(hdmi, REG_HDMI_DDC_CTRL,
> +                       hdmi_read(hdmi, REG_HDMI_DDC_CTRL) & ~BIT(1));
> +               DBG("After: HDMI_DDC_SW_STATUS=0x%08x",
> +                       hdmi_read(hdmi, REG_HDMI_DDC_SW_STATUS));
> +       }
> +

Just end the function here, no need for the extra debug printouts...

> +       hdcp_ddc_status = hdmi_read(hdmi, REG_HDMI_HDCP_DDC_STATUS);
> +
> +       failure = (hdcp_ddc_status >> 16) & BIT(0);
> +       nack0 = (hdcp_ddc_status >> 14) & BIT(0);
> +       DBG("On Exit: HDCP_DDC_STATUS=0x%x, FAIL=%d, NACK0=%d",
> +               hdcp_ddc_status, failure, nack0);
> +}
> +
> +static void hdmi_hdcp_hw_ddc_clean(struct hdmi_hdcp_ctrl *hdcp_ctrl)
> +{
> +       uint32_t hdcp_ddc_status, ddc_hw_status;
> +       uint32_t ddc_xfer_done, ddc_xfer_req, ddc_hw_done;
> +       uint32_t ddc_hw_not_ready;
> +       uint32_t timeout_count;
> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
> +
> +       if (hdmi_read(hdmi, REG_HDMI_DDC_HW_STATUS) == 0)
> +               return;
> +
> +       /* Wait to be clean on DDC HW engine */
> +       timeout_count = 100;
> +       do {
> +               hdcp_ddc_status = hdmi_read(hdmi, REG_HDMI_HDCP_DDC_STATUS);
> +               ddc_hw_status = hdmi_read(hdmi, REG_HDMI_DDC_HW_STATUS);

An empty line between the reads and the logic would make things much easier to
read.

> +               ddc_xfer_done = hdcp_ddc_status & BIT(10);
> +               ddc_xfer_req = hdcp_ddc_status & BIT(4);
> +               ddc_hw_done = ddc_hw_status & BIT(3);
> +               ddc_hw_not_ready = !ddc_xfer_done ||
> +                       ddc_xfer_req || !ddc_hw_done;
> +

if (!ddc_hw_not_ready)
break;

Simplifies the bottom part of the loop...and then flip the logic around to
remove the double negation.

> +               DBG("timeout count(%d):ddc hw%sready",
> +                       timeout_count, ddc_hw_not_ready ? " not " : " ");
> +               DBG("hdcp_ddc_status[0x%x], ddc_hw_status[0x%x]",
> +                       hdcp_ddc_status, ddc_hw_status);

Don't dump 200 lines of debug prints just because this times out.

> +               if (ddc_hw_not_ready)
> +                       msleep(20);
> +       } while (ddc_hw_not_ready && --timeout_count);
> +}
> +
> +/*
> + * Only retries defined times then abort current authenticating process
> + */
> +static int hdmi_msm_if_abort_reauth(struct hdmi_hdcp_ctrl *hdcp_ctrl)
> +{
> +       int rc = 0;
> +
> +       if (++hdcp_ctrl->auth_retries == AUTH_RETRIES_TIME) {
> +               mutex_lock(&hdcp_ctrl->state_mutex);
> +               hdcp_ctrl->hdcp_state = HDCP_STATE_INACTIVE;
> +               mutex_unlock(&hdcp_ctrl->state_mutex);
> +
> +               hdcp_ctrl->auth_retries = 0;
> +               rc = -ERANGE;
> +       }
> +
> +       return rc;
> +}
> +
> +static void hdmi_hdcp_reauth_work(struct work_struct *work)
> +{
> +       struct delayed_work *dw = to_delayed_work(work);
> +       struct hdmi_hdcp_ctrl *hdcp_ctrl = container_of(dw,
> +               struct hdmi_hdcp_ctrl, hdcp_reauth_work);
> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
> +       unsigned long flags;
> +       int rc;
> +
> +       DBG("HDCP REAUTH WORK");
> +       mutex_lock(&hdcp_ctrl->state_mutex);
> +       hdcp_ctrl->hdcp_state = HDCP_STATE_AUTH_FAIL;
> +       mutex_unlock(&hdcp_ctrl->state_mutex);
> +
> +       /*
> +        * Disable HPD circuitry.
> +        * This is needed to reset the HDCP cipher engine so that when we
> +        * attempt a re-authentication, HW would clear the AN0_READY and
> +        * AN1_READY bits in HDMI_HDCP_LINK0_STATUS register
> +        */
> +       spin_lock_irqsave(&hdmi->reg_lock, flags);
> +       hdmi_write(hdmi, REG_HDMI_HPD_CTRL,
> +               hdmi_read(hdmi, REG_HDMI_HPD_CTRL) & ~BIT(28));

Split things like this into:

val = hdmi_read(hdmi, REG_HDMI_HPD_CTRL);
val &= ~BIT(28);
hdmi_write(hdmi, REG_HDMI_HPD_CTRL,val);

For readability.

> +
> +       /* Disable HDCP interrupts */
> +       hdmi_write(hdmi, REG_HDMI_HDCP_INT_CTRL, 0);
> +       spin_unlock_irqrestore(&hdmi->reg_lock, flags);
> +
> +       hdmi_write(hdmi, REG_HDMI_HDCP_RESET, BIT(0));
> +
> +       /* Wait to be clean on DDC HW engine */
> +       hdmi_hdcp_hw_ddc_clean(hdcp_ctrl);
> +
> +       /* Disable encryption and disable the HDCP block */
> +       hdmi_write(hdmi, REG_HDMI_HDCP_CTRL, 0);
> +
> +       /* Enable HPD circuitry */
> +       spin_lock_irqsave(&hdmi->reg_lock, flags);
> +       hdmi_write(hdmi, REG_HDMI_HPD_CTRL,
> +               hdmi_read(hdmi, REG_HDMI_HPD_CTRL) | BIT(28));
> +       spin_unlock_irqrestore(&hdmi->reg_lock, flags);
> +
> +       rc = hdmi_msm_if_abort_reauth(hdcp_ctrl);

Just inline the hdmi_msm_if_abort_reauth() here, if you extract the state
handling to 1 worker function (that sleeps inbetween the steps) you don't need
to lock and there's not much code left in the function.

> +       if (rc) {
> +               pr_err("%s: abort reauthentication!\n", __func__);
> +               return;
> +       }
> +
> +       mutex_lock(&hdcp_ctrl->state_mutex);
> +       hdcp_ctrl->hdcp_state = HDCP_STATE_AUTHENTICATING;
> +       mutex_unlock(&hdcp_ctrl->state_mutex);
> +       queue_work(hdmi->workq, &hdcp_ctrl->hdcp_auth_prepare_work);
> +}
> +
> +static void hdmi_hdcp_auth_prepare_work(struct work_struct *work)
> +{
> +       struct hdmi_hdcp_ctrl *hdcp_ctrl = container_of(work,
> +               struct hdmi_hdcp_ctrl, hdcp_auth_prepare_work);
> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
> +       uint32_t qfprom_aksv_lsb, qfprom_aksv_msb;
> +       uint32_t link0_status;
> +       uint32_t regval;
> +       unsigned long flags;
> +       int ret;
> +
> +       if (!hdcp_ctrl->aksv_valid) {
> +               ret = hdmi_hdcp_read_validate_aksv(hdcp_ctrl);
> +               if (ret) {
> +                       pr_err("%s: ASKV validation failed\n", __func__);
> +                       mutex_lock(&hdcp_ctrl->state_mutex);
> +                       hdcp_ctrl->hdcp_state = HDCP_STATE_INACTIVE;
> +                       mutex_unlock(&hdcp_ctrl->state_mutex);
> +                       return;
> +               }
> +               hdcp_ctrl->aksv_valid = true;
> +       }
> +
> +       spin_lock_irqsave(&hdmi->reg_lock, flags);
> +       /* disable HDMI Encrypt */
> +       regval = hdmi_read(hdmi, REG_HDMI_CTRL);
> +       regval &= ~HDMI_CTRL_ENCRYPTED;
> +       hdmi_write(hdmi, REG_HDMI_CTRL, regval);
> +
> +       /* Enabling Software DDC */
> +       regval = hdmi_read(hdmi, REG_HDMI_DDC_ARBITRATION);
> +       regval &= ~HDMI_DDC_ARBITRATION_HW_ARBITRATION;
> +       hdmi_write(hdmi, REG_HDMI_DDC_ARBITRATION, regval);
> +       spin_unlock_irqrestore(&hdmi->reg_lock, flags);
> +
> +       /*
> +        * Write AKSV read from QFPROM to the HDCP registers.
> +        * This step is needed for HDCP authentication and must be
> +        * written before enabling HDCP.
> +        */
> +       qfprom_aksv_lsb = hdcp_ctrl->aksv[3];
> +       qfprom_aksv_lsb = (qfprom_aksv_lsb << 8) | hdcp_ctrl->aksv[2];
> +       qfprom_aksv_lsb = (qfprom_aksv_lsb << 8) | hdcp_ctrl->aksv[1];
> +       qfprom_aksv_lsb = (qfprom_aksv_lsb << 8) | hdcp_ctrl->aksv[0];
> +       qfprom_aksv_msb = hdcp_ctrl->aksv[4];

As noted when you extracted these, better just keep them as lsb and msg in
hdcp_ctrl.

> +       hdmi_write(hdmi, REG_HDMI_HDCP_SW_LOWER_AKSV, qfprom_aksv_lsb);
> +       hdmi_write(hdmi, REG_HDMI_HDCP_SW_UPPER_AKSV, qfprom_aksv_msb);
> +
> +       /*
> +        * HDCP setup prior to enabling HDCP_CTRL.
> +        * Setup seed values for random number An.
> +        */
> +       hdmi_write(hdmi, REG_HDMI_HDCP_ENTROPY_CTRL0, 0xB1FFB0FF);
> +       hdmi_write(hdmi, REG_HDMI_HDCP_ENTROPY_CTRL1, 0xF00DFACE);
> +
> +       /* Disable the RngCipher state */
> +       hdmi_write(hdmi, REG_HDMI_HDCP_DEBUG_CTRL,
> +               hdmi_read(hdmi, REG_HDMI_HDCP_DEBUG_CTRL) & ~(BIT(2)));
> +       DBG("HDCP_DEBUG_CTRL=0x%08x",
> +               hdmi_read(hdmi, REG_HDMI_HDCP_DEBUG_CTRL));
> +
> +       /*
> +        * Ensure that all register writes are completed before
> +        * enabling HDCP cipher
> +        */
> +       wmb();
> +
> +       /*
> +        * Enable HDCP
> +        * This needs to be done as early as possible in order for the
> +        * hardware to make An available to read
> +        */
> +       hdmi_write(hdmi, REG_HDMI_HDCP_CTRL, BIT(0));
> +
> +       /*
> +        * If we had stale values for the An ready bit, it should most
> +        * likely be cleared now after enabling HDCP cipher
> +        */
> +       link0_status = hdmi_read(hdmi, REG_HDMI_HDCP_LINK0_STATUS);
> +       DBG("After enabling HDCP Link0_Status=0x%08x", link0_status);
> +       if (!(link0_status & (BIT(8) | BIT(9))))
> +               DBG("An not ready after enabling HDCP");
> +
> +       /* Clear any DDC failures from previous tries before enable HDCP*/
> +       reset_hdcp_ddc_failures(hdcp_ctrl);
> +
> +       DBG("Queuing work to start HDCP authentication");
> +       hdcp_ctrl->work_retry_cnt = AUTH_WORK_RETRIES_TIME;
> +       queue_delayed_work(hdmi->workq,
> +               &hdcp_ctrl->hdcp_auth_part1_1_work, HZ/2);
> +}
> +
> +static void hdmi_hdcp_auth_fail(struct hdmi_hdcp_ctrl *hdcp_ctrl)
> +{
> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
> +       uint32_t regval;
> +       unsigned long flags;
> +
> +       DBG("hdcp auth failed, queue reauth work");
> +       /* clear HDMI Encrypt */
> +       spin_lock_irqsave(&hdmi->reg_lock, flags);
> +       regval = hdmi_read(hdmi, REG_HDMI_CTRL);
> +       regval &= ~HDMI_CTRL_ENCRYPTED;
> +       hdmi_write(hdmi, REG_HDMI_CTRL, regval);
> +       spin_unlock_irqrestore(&hdmi->reg_lock, flags);
> +       queue_delayed_work(hdmi->workq, &hdcp_ctrl->hdcp_reauth_work, HZ/2);
> +}
> +
> +static void hdmi_hdcp_auth_done(struct hdmi_hdcp_ctrl *hdcp_ctrl)
> +{
> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
> +       uint32_t regval;
> +       unsigned long flags;
> +
> +       /*
> +        * Disable software DDC before going into part3 to make sure
> +        * there is no Arbitration between software and hardware for DDC
> +        */
> +       spin_lock_irqsave(&hdmi->reg_lock, flags);
> +       regval = hdmi_read(hdmi, REG_HDMI_DDC_ARBITRATION);
> +       regval |= HDMI_DDC_ARBITRATION_HW_ARBITRATION;
> +       hdmi_write(hdmi, REG_HDMI_DDC_ARBITRATION, regval);
> +       spin_unlock_irqrestore(&hdmi->reg_lock, flags);
> +
> +       /*
> +        * Ensure that the state did not change during authentication.
> +        * If it did, it means that deauthenticate/reauthenticate was
> +        * called. In that case, this function doesn't need to enable encryption
> +        */
> +       mutex_lock(&hdcp_ctrl->state_mutex);
> +       if (HDCP_STATE_AUTHENTICATING == hdcp_ctrl->hdcp_state) {
> +               hdcp_ctrl->hdcp_state = HDCP_STATE_AUTHENTICATED;
> +               hdcp_ctrl->auth_retries = 0;
> +
> +               /* enable HDMI Encrypt */
> +               spin_lock_irqsave(&hdmi->reg_lock, flags);
> +               regval = hdmi_read(hdmi, REG_HDMI_CTRL);
> +               regval |= HDMI_CTRL_ENCRYPTED;
> +               hdmi_write(hdmi, REG_HDMI_CTRL, regval);
> +               spin_unlock_irqrestore(&hdmi->reg_lock, flags);
> +               mutex_unlock(&hdcp_ctrl->state_mutex);
> +       } else {
> +               mutex_unlock(&hdcp_ctrl->state_mutex);

Please move the mutex_unlock outside the if statement, and drop the else.

> +               DBG("HDCP state changed during authentication");
> +       }
> +}
> +
> +/*
> + * hdcp authenticating part 1: 1st
> + * Wait Key/An ready
> + * Read BCAPS from sink
> + * Write BCAPS and AKSV into HDCP engine
> + * Write An and AKSV to sink
> + * Read BKSV from sink and write into HDCP engine
> + */
> +static int hdmi_hdcp_check_key_an_ready(struct hdmi_hdcp_ctrl *hdcp_ctrl)
> +{
> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
> +       uint32_t link0_status, an_ready, keys_state;
> +
> +       link0_status = hdmi_read(hdmi, REG_HDMI_HDCP_LINK0_STATUS);
> +       /* Wait for HDCP keys to be checked and validated */
> +       keys_state = (link0_status >> 28) & 0x7;
> +       if (keys_state != HDCP_KEYS_STATE_VALID) {
> +               DBG("Keys not ready(%d). s=%d, l0=%0x08x",
> +                       hdcp_ctrl->work_retry_cnt,
> +                       keys_state, link0_status);
> +
> +               return -EAGAIN;
> +       }
> +
> +       /* Wait for An0 and An1 bit to be ready */
> +       an_ready = (link0_status & BIT(8)) && (link0_status & BIT(9));
> +       if (!an_ready) {
> +               DBG("An not ready(%d). l0_status=0x%08x",
> +                       hdcp_ctrl->work_retry_cnt, link0_status);
> +
> +               return -EAGAIN;
> +       }
> +
> +       return 0;
> +}
> +
> +static int hdmi_hdcp_send_aksv_an(struct hdmi_hdcp_ctrl *hdcp_ctrl)
> +{
> +       int rc = 0;
> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
> +       uint32_t link0_aksv_0, link0_aksv_1;
> +       uint32_t link0_an_0, link0_an_1;
> +       uint8_t aksv[5];
> +       uint8_t an[8];
> +
> +       /* Read An0 and An1 */
> +       link0_an_0 = hdmi_read(hdmi, REG_HDMI_HDCP_RCVPORT_DATA5);
> +       link0_an_1 = hdmi_read(hdmi, REG_HDMI_HDCP_RCVPORT_DATA6);
> +
> +       /* Read AKSV */
> +       link0_aksv_0 = hdmi_read(hdmi, REG_HDMI_HDCP_RCVPORT_DATA3);
> +       link0_aksv_1 = hdmi_read(hdmi, REG_HDMI_HDCP_RCVPORT_DATA4);
> +
> +       DBG("Link ASKV=%08x%08x", link0_aksv_0, link0_aksv_1);
> +       /* Copy An and AKSV to byte arrays for transmission */
> +       aksv[0] =  link0_aksv_0        & 0xFF;
> +       aksv[1] = (link0_aksv_0 >> 8)  & 0xFF;
> +       aksv[2] = (link0_aksv_0 >> 16) & 0xFF;
> +       aksv[3] = (link0_aksv_0 >> 24) & 0xFF;
> +       aksv[4] =  link0_aksv_1        & 0xFF;
> +
> +       an[0] =  link0_an_0        & 0xFF;
> +       an[1] = (link0_an_0 >> 8)  & 0xFF;
> +       an[2] = (link0_an_0 >> 16) & 0xFF;
> +       an[3] = (link0_an_0 >> 24) & 0xFF;
> +       an[4] =  link0_an_1        & 0xFF;
> +       an[5] = (link0_an_1 >> 8)  & 0xFF;
> +       an[6] = (link0_an_1 >> 16) & 0xFF;
> +       an[7] = (link0_an_1 >> 24) & 0xFF;
> +

Turn link0_an_{0,1} in an array of 2 u32 elements and possibly make sure that
they are little endian and then just call hdmi_ddc_write(..., &link0_an,
sizeof(link0_an));

> +       /* Write An to offset 0x18 */
> +       rc = hdmi_ddc_write(hdmi, HDCP_PORT_ADDR, 0x18, an, 8);
> +       if (rc) {
> +               pr_err("%s:An write failed\n", __func__);
> +               return rc;
> +       }
> +       DBG("Link0-An=%08x%08x", link0_an_1, link0_an_0);
> +
> +       /* Write AKSV to offset 0x10 */
> +       rc = hdmi_ddc_write(hdmi, HDCP_PORT_ADDR, 0x10, aksv, 5);
> +       if (rc) {
> +               pr_err("%s:AKSV write failed\n", __func__);
> +               return rc;
> +       }
> +       DBG("Link0-AKSV=%02x%08x", link0_aksv_1 & 0xFF, link0_aksv_0);
> +
> +       return 0;
> +}
> +
> +static int hdmi_hdcp_recv_bksv(struct hdmi_hdcp_ctrl *hdcp_ctrl)
> +{
> +       int rc = 0;
> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
> +       uint32_t link0_bksv_0, link0_bksv_1;
> +       uint8_t *bksv = NULL;
> +       uint32_t reg[2], data[2];
> +
> +       bksv = hdcp_ctrl->bksv;
> +
> +       /* Read BKSV at offset 0x00 */
> +       rc = hdmi_ddc_read(hdmi, HDCP_PORT_ADDR, 0x00, bksv, 5, true);
> +       if (rc) {
> +               pr_err("%s:BKSV read failed\n", __func__);
> +               return rc;
> +       }
> +
> +       /* check there are 20 ones in BKSV */
> +       if (hdmi_hdcp_count_one(bksv, 5) != 20) {
> +               pr_err(": BKSV doesn't have 20 1's and 20 0's\n");
> +               pr_err(": BKSV chk fail. BKSV=%02x%02x%02x%02x%02x\n",
> +                       bksv[4], bksv[3], bksv[2], bksv[1], bksv[0]);
> +               return -EINVAL;
> +       }
> +
> +       link0_bksv_0 = bksv[3];
> +       link0_bksv_0 = (link0_bksv_0 << 8) | bksv[2];
> +       link0_bksv_0 = (link0_bksv_0 << 8) | bksv[1];
> +       link0_bksv_0 = (link0_bksv_0 << 8) | bksv[0];
> +       link0_bksv_1 = bksv[4];

Either read these straight into two u32, or at least do:

a  = bksv[4];
b  = bksv[3] << 24;
b |= bksv[2] << 16;
b |= bksv[1] << 8;
b |= bksv[0];

> +       DBG(":BKSV=%02x%08x", link0_bksv_1, link0_bksv_0);
> +
> +       /* Write BKSV read from sink to HDCP registers */
> +       reg[0] = REG_HDMI_HDCP_RCVPORT_DATA0;
> +       data[0] = link0_bksv_0;
> +       reg[1] = REG_HDMI_HDCP_RCVPORT_DATA1;
> +       data[1] = link0_bksv_1;
> +       rc = hdmi_hdcp_scm_wr(hdcp_ctrl, reg, data, 2);
> +
> +       return rc;
> +}
> +
> +static int hdmi_hdcp_recv_bcaps(struct hdmi_hdcp_ctrl *hdcp_ctrl)
> +{
> +       int rc = 0;
> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
> +       uint32_t reg, data;
> +       uint8_t bcaps;
> +
> +       rc = hdmi_ddc_read(hdmi, HDCP_PORT_ADDR, 0x40, &bcaps, 1, true);
> +       if (rc) {
> +               pr_err("%s:BCAPS read failed\n", __func__);
> +               return rc;
> +       }
> +       DBG("BCAPS=%02x", bcaps);
> +
> +       /* receiver (0), repeater (1) */
> +       hdcp_ctrl->ds_type = (bcaps & BIT(6)) ? DS_REPEATER : DS_RECEIVER;
> +
> +       /* Write BCAPS to the hardware */
> +       reg = REG_HDMI_HDCP_RCVPORT_DATA12;
> +       data = (uint32_t)bcaps;

Just move these into the function call...

> +       rc = hdmi_hdcp_scm_wr(hdcp_ctrl, &reg, &data, 1);
> +
> +       return rc;
> +}
> +

[..]

> +
> +/*
> + * hdcp authenticating part 2: 1st
> + * wait until sink (repeater)'s ksv fifo ready
> + * read bstatus from sink and write to HDCP engine
> + */
> +static int hdmi_hdcp_recv_bstatus(struct hdmi_hdcp_ctrl *hdcp_ctrl,
> +       uint8_t bcaps)
> +{
> +       int rc;
> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
> +       uint16_t bstatus;
> +       bool max_devs_exceeded = false, max_cascade_exceeded = false;
> +       uint32_t repeater_cascade_depth = 0, down_stream_devices = 0;
> +       uint32_t reg, data;
> +       uint8_t buf[2];
> +
> +       memset(buf, 0, sizeof(buf));

If read returns okay buf should have been written to, so this should not be
needed.

> +
> +       /* Read BSTATUS at offset 0x41 */
> +       rc = hdmi_ddc_read(hdmi, HDCP_PORT_ADDR, 0x41, buf, 2, false);
> +       if (rc) {
> +               pr_err("%s: BSTATUS read failed\n", __func__);
> +               goto error;
> +       }
> +       bstatus = buf[1];
> +       bstatus = (bstatus << 8) | buf[0];

bstatus = buf[1] << 8 | buf[0];

> +

[..]

> +}
> +

[..]

> +
> +/*
> + * hdcp authenticating part 2: 2nd
> + * read ksv fifo from sink
> + * transfer V' from sink to HDCP engine
> + * reset SHA engine
> + */
> +int hdmi_hdcp_read_v(struct hdmi *hdmi, char *name,
> +       uint32_t off, uint32_t *val)
> +{

You can replace this entire function with:

hdmi_dcc_read(hdmi, HDCP_PORT_ADDR, off, val, sizeof(*val), true);

> +       int rc = 0;
> +       uint8_t buf[4];
> +
> +       rc = hdmi_ddc_read(hdmi, HDCP_PORT_ADDR, off, buf, 4, true);
> +       if (rc) {
> +               pr_err("%s: Read %s failed\n", __func__,
> +                       name);
> +               return rc;
> +       }
> +
> +       if (val)
> +               *val = (buf[3] << 24 | buf[2] << 16 | buf[1] << 8 | buf[0]);
> +
> +       DBG("%s: buf[0]=%x, buf[1]=%x, buf[2]=%x, buf[3]=%x", name,
> +               buf[0], buf[1], buf[2], buf[3]);
> +
> +       return rc;
> +}
> +
> +static int hdmi_hdcp_transfer_v_h(struct hdmi_hdcp_ctrl *hdcp_ctrl)
> +{
> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
> +       int rc = 0;
> +       struct hdmi_hdcp_reg_data reg_data[]  = {
> +               {REG_HDMI_HDCP_RCVPORT_DATA7,  0x20, "V' H0"},
> +               {REG_HDMI_HDCP_RCVPORT_DATA8,  0x24, "V' H1"},
> +               {REG_HDMI_HDCP_RCVPORT_DATA9,  0x28, "V' H2"},
> +               {REG_HDMI_HDCP_RCVPORT_DATA10, 0x2C, "V' H3"},
> +               {REG_HDMI_HDCP_RCVPORT_DATA11, 0x30, "V' H4"},
> +       };
> +       struct hdmi_hdcp_reg_data *rd;
> +       uint32_t size = ARRAY_SIZE(reg_data);
> +       uint32_t reg[ARRAY_SIZE(reg_data)], data[ARRAY_SIZE(reg_data)];

Move the data variable to it's own line to make things easier to read.

> +       int i;
> +
> +       for (i = 0; i < size; i++) {
> +               rd = &reg_data[i];
> +               rc = hdmi_hdcp_read_v(hdmi, rd->name,
> +                       rd->off, &data[i]);
> +               if (rc)
> +                       goto error;
> +
> +               reg[i] = reg_data[i].reg_id;
> +       }
> +
> +       rc = hdmi_hdcp_scm_wr(hdcp_ctrl, reg, data, size);
> +
> +error:
> +       return rc;
> +}
> +
> +static int hdmi_hdcp_recv_ksv_fifo(struct hdmi_hdcp_ctrl *hdcp_ctrl)
> +{
> +       int rc;
> +       struct hdmi *hdmi = hdcp_ctrl->hdmi;
> +       uint8_t *ksv_fifo = NULL;
> +       uint32_t ksv_bytes;
> +
> +       ksv_fifo = hdcp_ctrl->ksv_list;
> +       ksv_bytes = 5 * hdcp_ctrl->dev_count;
> +       memset(ksv_fifo, 0,
> +               sizeof(hdcp_ctrl->ksv_list));

Drop the local ksv_fifo and

memset(hdcp_ctrl->ksv_list, 0, sizeof(hdcp_ctrl->ksv_list));

as well as passing hdcp_ctrl->ksv_list to hdmi_ddc_read directly.

> +
> +       rc = hdmi_ddc_read(hdmi, HDCP_PORT_ADDR, 0x43,
> +               ksv_fifo, ksv_bytes, true);
> +       if (rc)
> +               pr_err("%s: KSV FIFO read failed\n", __func__);
> +
> +       return rc;
> +}
> +

[..]

> +int hdmi_hdcp_on(struct hdmi *hdmi)
> +{
> +       struct hdmi_hdcp_ctrl *hdcp_ctrl = hdmi->hdcp_ctrl;
> +       uint32_t regval;
> +       unsigned long flags;
> +
> +       if (!hdcp_ctrl) {
> +               pr_warn("%s:hdcp_ctrl is NULL\n", __func__);
> +               return 0;

There's little point in having a return value if you return success no matter
what.

> +       }
> +
> +       if (HDCP_STATE_INACTIVE != hdcp_ctrl->hdcp_state) {
> +               DBG("still active or activating. returning");
> +               return 0;
> +       }
> +
> +       /* clear HDMI Encrypt */
> +       spin_lock_irqsave(&hdmi->reg_lock, flags);
> +       regval = hdmi_read(hdmi, REG_HDMI_CTRL);
> +       regval &= ~HDMI_CTRL_ENCRYPTED;
> +       hdmi_write(hdmi, REG_HDMI_CTRL, regval);
> +       spin_unlock_irqrestore(&hdmi->reg_lock, flags);
> +
> +       mutex_lock(&hdcp_ctrl->state_mutex);
> +       hdcp_ctrl->hdcp_state = HDCP_STATE_AUTHENTICATING;
> +       mutex_unlock(&hdcp_ctrl->state_mutex);
> +       hdcp_ctrl->auth_retries = 0;
> +       queue_work(hdmi->workq, &hdcp_ctrl->hdcp_auth_prepare_work);
> +
> +       return 0;
> +}
> +
> +void hdmi_hdcp_off(struct hdmi *hdmi)
> +{
> +       struct hdmi_hdcp_ctrl *hdcp_ctrl = hdmi->hdcp_ctrl;
> +       unsigned long flags;
> +       uint32_t regval;
> +       int rc = 0;
> +
> +       if (!hdcp_ctrl) {
> +               pr_err("%s:hdcp_ctrl is NULL\n", __func__);
> +               return;
> +       }
> +
> +       if (HDCP_STATE_INACTIVE == hdcp_ctrl->hdcp_state) {
> +               DBG("hdcp inactive. returning");
> +               return;
> +       }
> +
> +       /*
> +        * Disable HPD circuitry.
> +        * This is needed to reset the HDCP cipher engine so that when we
> +        * attempt a re-authentication, HW would clear the AN0_READY and
> +        * AN1_READY bits in HDMI_HDCP_LINK0_STATUS register
> +        */
> +       spin_lock_irqsave(&hdmi->reg_lock, flags);
> +       hdmi_write(hdmi, REG_HDMI_HPD_CTRL,
> +               hdmi_read(hdmi, REG_HDMI_HPD_CTRL) & ~BIT(28));

Split into:
val = read();
val &= ~BIT(28);
write(val);

Please put 28 in a define with a sane name related to HDP circuitry...

> +
> +       /*
> +        * Disable HDCP interrupts.
> +        * Also, need to set the state to inactive here so that any ongoing
> +        * reauth works will know that the HDCP session has been turned off.
> +        */
> +       hdmi_write(hdmi, REG_HDMI_HDCP_INT_CTRL, 0);
> +       spin_unlock_irqrestore(&hdmi->reg_lock, flags);
> +
> +       /*
> +        * Cancel any pending auth/reauth attempts.
> +        * If one is ongoing, this will wait for it to finish.
> +        * No more reauthentication attempts will be scheduled since we
> +        * set the current state to inactive.
> +        */
> +       rc = cancel_work_sync(&hdcp_ctrl->hdcp_auth_prepare_work);
> +       if (rc)
> +               DBG("Deleted hdcp auth prepare work");
> +       rc = cancel_delayed_work_sync(&hdcp_ctrl->hdcp_reauth_work);
> +       if (rc)
> +               DBG("Deleted hdcp reauth work");
> +       rc = cancel_delayed_work_sync(&hdcp_ctrl->hdcp_auth_part1_1_work);
> +       if (rc)
> +               DBG("Deleted hdcp auth part1_1 work");
> +       rc = cancel_delayed_work_sync(&hdcp_ctrl->hdcp_auth_part1_2_work);
> +       if (rc)
> +               DBG("Deleted hdcp auth part1_2 work");
> +       rc = cancel_work_sync(&hdcp_ctrl->hdcp_auth_part1_3_work);
> +       if (rc)
> +               DBG("Deleted hdcp auth part1_3 work");
> +       rc = cancel_delayed_work_sync(&hdcp_ctrl->hdcp_auth_part2_1_work);
> +       if (rc)
> +               DBG("Deleted hdcp auth part2_1 work");
> +       rc = cancel_delayed_work_sync(&hdcp_ctrl->hdcp_auth_part2_2_work);
> +       if (rc)
> +               DBG("Deleted hdcp auth part2_2 work");
> +       rc = cancel_delayed_work_sync(&hdcp_ctrl->hdcp_auth_part2_3_work);
> +       if (rc)
> +               DBG("Deleted hdcp auth part2_3 work");
> +       rc = cancel_delayed_work_sync(&hdcp_ctrl->hdcp_auth_part2_4_work);
> +       if (rc)
> +               DBG("Deleted hdcp auth part2_4 work");

Just drop all these debug printouts, they don't add anything but clutter.

> +
> +       /* set state to inactive after all work cancelled */
> +       mutex_lock(&hdcp_ctrl->state_mutex);
> +       hdcp_ctrl->hdcp_state = HDCP_STATE_INACTIVE;
> +       mutex_unlock(&hdcp_ctrl->state_mutex);

You shouldn't have to lock here, your workers are dead.

> +
> +       hdmi_write(hdmi, REG_HDMI_HDCP_RESET, BIT(0));
> +
> +       /* Disable encryption and disable the HDCP block */
> +       hdmi_write(hdmi, REG_HDMI_HDCP_CTRL, 0);
> +
> +       spin_lock_irqsave(&hdmi->reg_lock, flags);
> +       regval = hdmi_read(hdmi, REG_HDMI_CTRL);
> +       regval &= ~HDMI_CTRL_ENCRYPTED;
> +       hdmi_write(hdmi, REG_HDMI_CTRL, regval);
> +
> +       /* Enable HPD circuitry */
> +       hdmi_write(hdmi, REG_HDMI_HPD_CTRL,
> +               hdmi_read(hdmi, REG_HDMI_HPD_CTRL) | BIT(28));

Split it into:
val = read()
val |= BIT(28);
write(val);

> +       spin_unlock_irqrestore(&hdmi->reg_lock, flags);
> +
> +       DBG("HDCP: Off");
> +} /* hdmi_hdcp_off */

Remove the comment.

> +
> +struct hdmi_hdcp_ctrl *hdmi_hdcp_init(struct hdmi *hdmi)
> +{
> +       uint32_t scm_buf = TZ_HDCP_CMD_ID;
> +       struct hdmi_hdcp_ctrl *hdcp_ctrl;
> +       uint32_t ret  = 0;
> +       uint32_t resp = 0;
> +
> +       if (!hdmi->qfprom_mmio) {
> +               pr_err("%s: HDCP is not supported without qfprom\n",
> +                       __func__);
> +               ret = -EINVAL;
> +               goto fail;

Just return here directly.

> +       }
> +
> +       hdcp_ctrl = kzalloc(sizeof(*hdcp_ctrl), GFP_KERNEL);
> +       if (!hdcp_ctrl) {
> +               ret = -ENOMEM;
> +               goto fail;
> +       }
> +
> +       INIT_WORK(&hdcp_ctrl->hdcp_auth_prepare_work,
> +               hdmi_hdcp_auth_prepare_work);
> +       INIT_DELAYED_WORK(&hdcp_ctrl->hdcp_reauth_work, hdmi_hdcp_reauth_work);
> +       INIT_DELAYED_WORK(&hdcp_ctrl->hdcp_auth_part1_1_work,
> +               hdmi_hdcp_auth_part1_1_work);
> +       INIT_DELAYED_WORK(&hdcp_ctrl->hdcp_auth_part1_2_work,
> +               hdmi_hdcp_auth_part1_2_work);
> +       INIT_WORK(&hdcp_ctrl->hdcp_auth_part1_3_work,
> +               hdmi_hdcp_auth_part1_3_work);
> +       INIT_DELAYED_WORK(&hdcp_ctrl->hdcp_auth_part2_1_work,
> +               hdmi_hdcp_auth_part2_1_work);
> +       INIT_DELAYED_WORK(&hdcp_ctrl->hdcp_auth_part2_2_work,
> +               hdmi_hdcp_auth_part2_2_work);
> +       INIT_DELAYED_WORK(&hdcp_ctrl->hdcp_auth_part2_3_work,
> +               hdmi_hdcp_auth_part2_3_work);
> +       INIT_DELAYED_WORK(&hdcp_ctrl->hdcp_auth_part2_4_work,
> +               hdmi_hdcp_auth_part2_4_work);
> +

As I stated before, replace all these steps with one worker function
that does something like:

{
if (state == AUTHENTICATED)
re_auth();

auth_prepare();
msleep(500);

while (auth_part_1_1() == -EAGAIN)
msleep(20);

msleep(160);

auth_part_1_2();
...
}

> +       hdcp_ctrl->hdmi = hdmi;
> +       hdcp_ctrl->hdcp_state = HDCP_STATE_INACTIVE;
> +       mutex_init(&hdcp_ctrl->state_mutex);
> +       hdcp_ctrl->aksv_valid = false;
> +
> +       ret = scm_call(SCM_SVC_INFO, SCM_CMD_HDCP, &scm_buf,
> +               sizeof(scm_buf), &resp, sizeof(resp));

You're calling command 1 on SCM_SVC_INFO, this is not SCM_CMD_HDCP but rather
IS_CALL_AVAIL_CMD. The parameter, 0x00004401, is 17 << 10 | 1; meaning service
17 command 1.

You should use [1] and replace this with:

ret = scm_is_call_available(SCM_SVC_HDCP, SCM_CMD_HDCP);

> +       if (ret) {
> +               pr_err("%s: error: scm_call ret = %d, resp = %d\n",
> +                       __func__, ret, resp);
> +               goto fail;
> +       } else {

There's no need for the else here, as you just goto'ed.

> +               DBG("tz_hdcp = %d", resp);
> +               hdcp_ctrl->tz_hdcp = resp;
> +       }
> +
> +       return hdcp_ctrl;
> +fail:
> +       kfree(hdcp_ctrl);
> +       return ERR_PTR(ret);
> +} /* hdmi_hdcp_init */

Drop the comment.

> +
> +void hdmi_hdcp_destroy(struct hdmi *hdmi)
> +{
> +       if (hdmi && hdmi->hdcp_ctrl) {
> +               kfree(hdmi->hdcp_ctrl);
> +               hdmi->hdcp_ctrl = NULL;
> +       }
> +}

[1] https://lkml.org/lkml/2014/8/4/768

Regards,
Bjorn
