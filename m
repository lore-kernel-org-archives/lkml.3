Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750918AbaEXEDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 00:03:07 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:51675 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaEXEDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 00:03:05 -0400
MIME-Version: 1.0
In-Reply-To: <537F0840.5030105@xs4all.nl>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
 <1400247235-31434-6-git-send-email-prabhakar.csengg@gmail.com> <537F0840.5030105@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 24 May 2014 09:32:32 +0530
Message-ID: <CA+V-a8uysAhY7bV--C8tOw83=iSRtPf=HSp--Vt-7S2njgR3vg@mail.gmail.com>
Subject: Re: [PATCH v5 04/49] media: davinci: vpif_display: release buffers in
 case start_streaming() call back fails
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Thanks for the review.

On Fri, May 23, 2014 at 2:05 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 05/16/2014 03:33 PM, Lad, Prabhakar wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> this patch adds support to release the buffer by calling
>> vb2_buffer_done(), with state marked as VB2_BUF_STATE_QUEUED
>> if start_streaming() call back fails.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  drivers/media/platform/davinci/vpif_display.c |   42 +++++++++++++++----------
>>  1 file changed, 26 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
>> index 8bb9f02..1a17a45 100644
>> --- a/drivers/media/platform/davinci/vpif_display.c
>> +++ b/drivers/media/platform/davinci/vpif_display.c
>> @@ -196,26 +196,16 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>>       struct channel_obj *ch = vb2_get_drv_priv(vq);
>>       struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
>>       struct vpif_params *vpif = &ch->vpifparams;
>> -     unsigned long addr = 0;
>> -     unsigned long flags;
>> +     struct vpif_disp_buffer *buf, *tmp;
>> +     unsigned long addr, flags;
>>       int ret;
>>
>>       spin_lock_irqsave(&common->irqlock, flags);
>>
>> -     /* Get the next frame from the buffer queue */
>> -     common->next_frm = common->cur_frm =
>> -                         list_entry(common->dma_queue.next,
>> -                                    struct vpif_disp_buffer, list);
>> -
>> -     list_del(&common->cur_frm->list);
>> -     spin_unlock_irqrestore(&common->irqlock, flags);
>> -     /* Mark state of the current frame to active */
>> -     common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
>> -
>>       /* Initialize field_id and started member */
>>       ch->field_id = 0;
>>       common->started = 1;
>> -     addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
>> +
>>       /* Calculate the offset for Y and C data  in the buffer */
>>       vpif_calculate_offsets(ch);
>>
>> @@ -225,7 +215,8 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>>               || (!ch->vpifparams.std_info.frm_fmt
>>               && (common->fmt.fmt.pix.field == V4L2_FIELD_NONE))) {
>>               vpif_err("conflict in field format and std format\n");
>> -             return -EINVAL;
>> +             ret = -EINVAL;
>> +             goto err;
>>       }
>>
>>       /* clock settings */
>> @@ -234,17 +225,28 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>>               ycmux_mode, ch->vpifparams.std_info.hd_sd);
>>               if (ret < 0) {
>>                       vpif_err("can't set clock\n");
>> -                     return ret;
>> +                     goto err;
>>               }
>>       }
>>
>>       /* set the parameters and addresses */
>>       ret = vpif_set_video_params(vpif, ch->channel_id + 2);
>>       if (ret < 0)
>> -             return ret;
>> +             goto err;
>>
>>       common->started = ret;
>>       vpif_config_addr(ch, ret);
>> +     /* Get the next frame from the buffer queue */
>> +     common->next_frm = common->cur_frm =
>> +                         list_entry(common->dma_queue.next,
>> +                                    struct vpif_disp_buffer, list);
>> +
>> +     list_del(&common->cur_frm->list);
>> +     spin_unlock_irqrestore(&common->irqlock, flags);
>> +     /* Mark state of the current frame to active */
>> +     common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
>
> There is no need to set this, all buffers queued to the driver are always in state
> ACTIVE. The vb2 core sets that for you. In general drivers never need to change the
> state manually.
>
> It happens twice in this driver and in both cases the assignment can be removed.
>
OK, will drop this.

Regards,
--Prabhakar Lad
