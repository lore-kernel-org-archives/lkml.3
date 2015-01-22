Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbbAVW1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:27:34 -0500
Received: from lists.s-osg.org ([54.187.51.154]:53894 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbbAVW13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:27:29 -0500
Message-ID: <54C1794E.3050901@osg.samsung.com>
Date: Thu, 22 Jan 2015 15:27:26 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        laurent pinchart <laurent.pinchart@ideasonboard.com>,
        ttmesterr <ttmesterr@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] media: au0828 - convert to use videobuf2
References: <cover.1421115389.git.shuahkh@osg.samsung.com> <9642c73eb38234cd69059c4a64bfde5205d637c2.1421115389.git.shuahkh@osg.samsung.com> <CA+V-a8uzfcyhO0vA2Jxg8YJYrHtk_b0skhN4kGCwO81X9yF--w@mail.gmail.com> <54C12240.2050702@osg.samsung.com> <CA+V-a8t1TdsdFC1092Zy_-v0HEHQr9FgMzGq5jYR_kVNCOTMTA@mail.gmail.com>
In-Reply-To: <CA+V-a8t1TdsdFC1092Zy_-v0HEHQr9FgMzGq5jYR_kVNCOTMTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 01:47 PM, Lad, Prabhakar wrote:
> Hi Shuah,
> 
> On Thu, Jan 22, 2015 at 4:16 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
>> Hi Prabhakar,
>>
> [snip]
>>>> +       buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
>>>> +       v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
>>>> +       vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
>>>>  }
>>>>
>>> Why not just have one single buffer_filled function ? just check the
>>> queue type and assign the dev->isoc_ctl.buf/ dev->isoc_ctl.vbi_buf
>>> to NULL.
>>
>> Yes. These two routines could be collapsed into a single. Is it okay if
>> I made that change in a separate patch?
>>
> hmm.. this can go as a separate patch.

Thanks. Looked into this a bit more. It is definitely better done as a
separate patch.

> 
>>>
>>>>  /*
>>>> @@ -353,8 +340,8 @@ static void au0828_copy_video(struct au0828_dev *dev,
>>>>         if (len == 0)
>>>>                 return;
>>>>
>>>> -       if (dma_q->pos + len > buf->vb.size)
>>>> -               len = buf->vb.size - dma_q->pos;
>>>> +       if (dma_q->pos + len > buf->length)
>>>> +               len = buf->length - dma_q->pos;
>>>>
>>>>         startread = p;
>>>>         remain = len;
>>>> @@ -372,11 +359,11 @@ static void au0828_copy_video(struct au0828_dev *dev,
>>>>         lencopy = bytesperline - currlinedone;
>>>>         lencopy = lencopy > remain ? remain : lencopy;
>>>>
>>>> -       if ((char *)startwrite + lencopy > (char *)outp + buf->vb.size) {
>>>> +       if ((char *)startwrite + lencopy > (char *)outp + buf->length) {
>>>>                 au0828_isocdbg("Overflow of %zi bytes past buffer end (1)\n",
>>>>                                ((char *)startwrite + lencopy) -
>>>> -                              ((char *)outp + buf->vb.size));
>>>> -               remain = (char *)outp + buf->vb.size - (char *)startwrite;
>>>> +                              ((char *)outp + buf->length));
>>>> +               remain = (char *)outp + buf->length - (char *)startwrite;
>>>>                 lencopy = remain;
>>>>         }
>>>>         if (lencopy <= 0)
>>>> @@ -394,11 +381,11 @@ static void au0828_copy_video(struct au0828_dev *dev,
>>>>                         lencopy = bytesperline;
>>>>
>>>>                 if ((char *)startwrite + lencopy > (char *)outp +
>>>> -                   buf->vb.size) {
>>>> +                   buf->length) {
>>>>                         au0828_isocdbg("Overflow %zi bytes past buf end (2)\n",
>>>>                                        ((char *)startwrite + lencopy) -
>>>> -                                      ((char *)outp + buf->vb.size));
>>>> -                       lencopy = remain = (char *)outp + buf->vb.size -
>>>> +                                      ((char *)outp + buf->length));
>>>> +                       lencopy = remain = (char *)outp + buf->length -
>>>>                                            (char *)startwrite;
>>>>                 }
>>>>                 if (lencopy <= 0)
>>>> @@ -434,7 +421,11 @@ static inline void get_next_buf(struct au0828_dmaqueue *dma_q,
>>>>         }
>>>>
>>>>         /* Get the next buffer */
>>>> -       *buf = list_entry(dma_q->active.next, struct au0828_buffer, vb.queue);
>>>> +       *buf = list_entry(dma_q->active.next, struct au0828_buffer, list);
>>>> +       /* Cleans up buffer - Useful for testing for frame/URB loss */
>>>> +       list_del(&(*buf)->list);
>>>> +       dma_q->pos = 0;
>>>> +       (*buf)->vb_buf = (*buf)->mem;
>>>>         dev->isoc_ctl.buf = *buf;
>>>>
>>>>         return;
>>>> @@ -472,8 +463,8 @@ static void au0828_copy_vbi(struct au0828_dev *dev,
>>>>
>>>>         bytesperline = dev->vbi_width;
>>>>
>>>> -       if (dma_q->pos + len > buf->vb.size)
>>>> -               len = buf->vb.size - dma_q->pos;
>>>> +       if (dma_q->pos + len > buf->length)
>>>> +               len = buf->length - dma_q->pos;
>>>>
>>>>         startread = p;
>>>>         startwrite = outp + (dma_q->pos / 2);
>>>> @@ -496,7 +487,6 @@ static inline void vbi_get_next_buf(struct au0828_dmaqueue *dma_q,
>>>>                                     struct au0828_buffer **buf)
>>>>  {
>>>>         struct au0828_dev *dev = container_of(dma_q, struct au0828_dev, vbiq);
>>>> -       char *outp;
>>>>
>>>>         if (list_empty(&dma_q->active)) {
>>>>                 au0828_isocdbg("No active queue to serve\n");
>>>> @@ -506,13 +496,12 @@ static inline void vbi_get_next_buf(struct au0828_dmaqueue *dma_q,
>>>>         }
>>>>
>>>>         /* Get the next buffer */
>>>> -       *buf = list_entry(dma_q->active.next, struct au0828_buffer, vb.queue);
>>>> +       *buf = list_entry(dma_q->active.next, struct au0828_buffer, list);
>>>>         /* Cleans up buffer - Useful for testing for frame/URB loss */
>>>> -       outp = videobuf_to_vmalloc(&(*buf)->vb);
>>>> -       memset(outp, 0x00, (*buf)->vb.size);
>>>> -
>>>> +       list_del(&(*buf)->list);
>>>> +       dma_q->pos = 0;
>>>> +       (*buf)->vb_buf = (*buf)->mem;
>>>>         dev->isoc_ctl.vbi_buf = *buf;
>>>> -
>>>>         return;
>>>>  }
>>>>
>>>> @@ -548,11 +537,11 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
>>>>
>>>>         buf = dev->isoc_ctl.buf;
>>>>         if (buf != NULL)
>>>> -               outp = videobuf_to_vmalloc(&buf->vb);
>>>> +               outp = vb2_plane_vaddr(&buf->vb, 0);
>>>>
>>>>         vbi_buf = dev->isoc_ctl.vbi_buf;
>>>>         if (vbi_buf != NULL)
>>>> -               vbioutp = videobuf_to_vmalloc(&vbi_buf->vb);
>>>> +               vbioutp = vb2_plane_vaddr(&vbi_buf->vb, 0);
>>>>
>>>>         for (i = 0; i < urb->number_of_packets; i++) {
>>>>                 int status = urb->iso_frame_desc[i].status;
>>>> @@ -592,8 +581,8 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
>>>>                                 if (vbi_buf == NULL)
>>>>                                         vbioutp = NULL;
>>>>                                 else
>>>> -                                       vbioutp = videobuf_to_vmalloc(
>>>> -                                               &vbi_buf->vb);
>>>> +                                       vbioutp = vb2_plane_vaddr(
>>>> +                                               &vbi_buf->vb, 0);
>>>>
>>>>                                 /* Video */
>>>>                                 if (buf != NULL)
>>>> @@ -602,7 +591,7 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
>>>>                                 if (buf == NULL)
>>>>                                         outp = NULL;
>>>>                                 else
>>>> -                                       outp = videobuf_to_vmalloc(&buf->vb);
>>>> +                                       outp = vb2_plane_vaddr(&buf->vb, 0);
>>>>
>>>>                                 /* As long as isoc traffic is arriving, keep
>>>>                                    resetting the timer */
>>>> @@ -656,130 +645,59 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
>>>>         return rc;
>>>>  }
>>>>
>>>> -static int
>>>> -buffer_setup(struct videobuf_queue *vq, unsigned int *count,
>>>> -            unsigned int *size)
>>>> +static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
>>>> +                      unsigned int *nbuffers, unsigned int *nplanes,
>>>> +                      unsigned int sizes[], void *alloc_ctxs[])
>>>>  {
>>>> -       struct au0828_fh *fh = vq->priv_data;
>>>> -       *size = (fh->dev->width * fh->dev->height * 16 + 7) >> 3;
>>>> -
>>>> -       if (0 == *count)
>>>> -               *count = AU0828_DEF_BUF;
>>>> +       struct au0828_dev *dev = vb2_get_drv_priv(vq);
>>>> +       unsigned long img_size = dev->height * dev->bytesperline;
>>>> +       unsigned long size;
>>>>
>>>> -       if (*count < AU0828_MIN_BUF)
>>>> -               *count = AU0828_MIN_BUF;
>>>> -       return 0;
>>>> -}
>>>> +       size = fmt ? fmt->fmt.pix.sizeimage : img_size;
>>>> +       if (size < img_size)
>>>> +               return -EINVAL;
>>>>
>>>> -/* This is called *without* dev->slock held; please keep it that way */
>>>> -static void free_buffer(struct videobuf_queue *vq, struct au0828_buffer *buf)
>>>> -{
>>>> -       struct au0828_fh     *fh  = vq->priv_data;
>>>> -       struct au0828_dev    *dev = fh->dev;
>>>> -       unsigned long flags = 0;
>>>> -       if (in_interrupt())
>>>> -               BUG();
>>>> -
>>>> -       /* We used to wait for the buffer to finish here, but this didn't work
>>>> -          because, as we were keeping the state as VIDEOBUF_QUEUED,
>>>> -          videobuf_queue_cancel marked it as finished for us.
>>>> -          (Also, it could wedge forever if the hardware was misconfigured.)
>>>> -
>>>> -          This should be safe; by the time we get here, the buffer isn't
>>>> -          queued anymore. If we ever start marking the buffers as
>>>> -          VIDEOBUF_ACTIVE, it won't be, though.
>>>> -       */
>>>> -       spin_lock_irqsave(&dev->slock, flags);
>>>> -       if (dev->isoc_ctl.buf == buf)
>>>> -               dev->isoc_ctl.buf = NULL;
>>>> -       spin_unlock_irqrestore(&dev->slock, flags);
>>>> +       *nplanes = 1;
>>>> +       sizes[0] = size;
>>>>
>>>> -       videobuf_vmalloc_free(&buf->vb);
>>>> -       buf->vb.state = VIDEOBUF_NEEDS_INIT;
>>>> +       return 0;
>>>>  }
>>>>
>>>>  static int
>>>> -buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
>>>> -                                               enum v4l2_field field)
>>>> +buffer_prepare(struct vb2_buffer *vb)
>>>>  {
>>>> -       struct au0828_fh     *fh  = vq->priv_data;
>>>>         struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
>>>> -       struct au0828_dev    *dev = fh->dev;
>>>> -       int                  rc = 0, urb_init = 0;
>>>> +       struct au0828_dev    *dev = vb2_get_drv_priv(vb->vb2_queue);
>>>>
>>>> -       buf->vb.size = (fh->dev->width * fh->dev->height * 16 + 7) >> 3;
>>>> +       buf->length = dev->height * dev->bytesperline;
>>>>
>>>> -       if (0 != buf->vb.baddr  &&  buf->vb.bsize < buf->vb.size)
>>>> +       if (vb2_plane_size(vb, 0) < buf->length) {
>>>> +               pr_err("%s data will not fit into plane (%lu < %lu)\n",
>>>> +                       __func__, vb2_plane_size(vb, 0), buf->length);
>>>>                 return -EINVAL;
>>>> -
>>>> -       buf->vb.width  = dev->width;
>>>> -       buf->vb.height = dev->height;
>>>> -       buf->vb.field  = field;
>>>> -
>>>> -       if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
>>>> -               rc = videobuf_iolock(vq, &buf->vb, NULL);
>>>> -               if (rc < 0) {
>>>> -                       pr_info("videobuf_iolock failed\n");
>>>> -                       goto fail;
>>>> -               }
>>>>         }
>>>> -
>>>> -       if (!dev->isoc_ctl.num_bufs)
>>>> -               urb_init = 1;
>>>> -
>>>> -       if (urb_init) {
>>>> -               rc = au0828_init_isoc(dev, AU0828_ISO_PACKETS_PER_URB,
>>>> -                                     AU0828_MAX_ISO_BUFS, dev->max_pkt_size,
>>>> -                                     au0828_isoc_copy);
>>>> -               if (rc < 0) {
>>>> -                       pr_info("au0828_init_isoc failed\n");
>>>> -                       goto fail;
>>>> -               }
>>>> -       }
>>>> -
>>>> -       buf->vb.state = VIDEOBUF_PREPARED;
>>>> +       vb2_set_plane_payload(&buf->vb, 0, buf->length);
>>>>         return 0;
>>>> -
>>>> -fail:
>>>> -       free_buffer(vq, buf);
>>>> -       return rc;
>>>>  }
>>>>
>>>>  static void
>>>> -buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
>>>> +buffer_queue(struct vb2_buffer *vb)
>>>>  {
>>>>         struct au0828_buffer    *buf     = container_of(vb,
>>>>                                                         struct au0828_buffer,
>>>>                                                         vb);
>>>> -       struct au0828_fh        *fh      = vq->priv_data;
>>>> -       struct au0828_dev       *dev     = fh->dev;
>>>> +       struct au0828_dev       *dev     = vb2_get_drv_priv(vb->vb2_queue);
>>>>         struct au0828_dmaqueue  *vidq    = &dev->vidq;
>>>> +       unsigned long flags = 0;
>>>>
>>>> -       buf->vb.state = VIDEOBUF_QUEUED;
>>>> -       list_add_tail(&buf->vb.queue, &vidq->active);
>>>> -}
>>>> -
>>>> -static void buffer_release(struct videobuf_queue *vq,
>>>> -                               struct videobuf_buffer *vb)
>>>> -{
>>>> -       struct au0828_buffer   *buf  = container_of(vb,
>>>> -                                                   struct au0828_buffer,
>>>> -                                                   vb);
>>>> +       buf->mem = vb2_plane_vaddr(vb, 0);
>>>> +       buf->length = vb2_plane_size(vb, 0);
>>>>
>>>> -       free_buffer(vq, buf);
>>>> +       spin_lock_irqsave(&dev->slock, flags);
>>>> +       list_add_tail(&buf->list, &vidq->active);
>>>> +       spin_unlock_irqrestore(&dev->slock, flags);
>>>>  }
>>>>
>>>> -static struct videobuf_queue_ops au0828_video_qops = {
>>>> -       .buf_setup      = buffer_setup,
>>>> -       .buf_prepare    = buffer_prepare,
>>>> -       .buf_queue      = buffer_queue,
>>>> -       .buf_release    = buffer_release,
>>>> -};
>>>> -
>>>> -/* ------------------------------------------------------------------
>>>> -   V4L2 interface
>>>> -   ------------------------------------------------------------------*/
>>>> -
>>>>  static int au0828_i2s_init(struct au0828_dev *dev)
>>>>  {
>>>>         /* Enable i2s mode */
>>>> @@ -828,7 +746,7 @@ static int au0828_analog_stream_enable(struct au0828_dev *d)
>>>>         return 0;
>>>>  }
>>>>
>>>> -int au0828_analog_stream_disable(struct au0828_dev *d)
>>>> +static int au0828_analog_stream_disable(struct au0828_dev *d)
>>>>  {
>>>>         dprintk(1, "au0828_analog_stream_disable called\n");
>>>>         au0828_writereg(d, AU0828_SENSORCTRL_100, 0x0);
>>>> @@ -861,78 +779,141 @@ static int au0828_stream_interrupt(struct au0828_dev *dev)
>>>>         return 0;
>>>>  }
>>>>
>>>> -/*
>>>> - * au0828_release_resources
>>>> - * unregister v4l2 devices
>>>> - */
>>>> -void au0828_analog_unregister(struct au0828_dev *dev)
>>>> +int au0828_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
>>>>  {
>>>> -       dprintk(1, "au0828_release_resources called\n");
>>>> -       mutex_lock(&au0828_sysfs_lock);
>>>> +       struct au0828_dev *dev = vb2_get_drv_priv(vq);
>>>> +       int rc = 0;
>>>>
>>>> -       if (dev->vdev)
>>>> -               video_unregister_device(dev->vdev);
>>>> -       if (dev->vbi_dev)
>>>> -               video_unregister_device(dev->vbi_dev);
>>>> +       dprintk(1, "au0828_start_analog_streaming called %d\n",
>>>> +               dev->streaming_users);
>>>>
>>>> -       mutex_unlock(&au0828_sysfs_lock);
>>>> -}
>>>> +       if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
>>>> +               dev->frame_count = 0;
>>>> +       else
>>>> +               dev->vbi_frame_count = 0;
>>>> +
>>>> +       if (dev->streaming_users == 0) {
>>>> +               /* If we were doing ac97 instead of i2s, it would go here...*/
>>>> +               au0828_i2s_init(dev);
>>>> +               rc = au0828_init_isoc(dev, AU0828_ISO_PACKETS_PER_URB,
>>>> +                                  AU0828_MAX_ISO_BUFS, dev->max_pkt_size,
>>>> +                                  au0828_isoc_copy);
>>>> +               if (rc < 0) {
>>>> +                       pr_info("au0828_init_isoc failed\n");
>>>> +                       return rc;
>>>> +               }
>>>>
>>>> +               if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
>>>> +                       v4l2_device_call_all(&dev->v4l2_dev, 0, video,
>>>> +                                               s_stream, 1);
>>>> +                       dev->vid_timeout_running = 1;
>>>> +                       mod_timer(&dev->vid_timeout, jiffies + (HZ / 10));
>>>> +               } else if (vq->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
>>>> +                       dev->vbi_timeout_running = 1;
>>>> +                       mod_timer(&dev->vbi_timeout, jiffies + (HZ / 10));
>>>> +               }
>>>> +       }
>>>> +       dev->streaming_users++;
>>>> +       return rc;
>>>> +}
>>>>
>>>> -/* Usage lock check functions */
>>>> -static int res_get(struct au0828_fh *fh, unsigned int bit)
>>>> +static void au0828_stop_streaming(struct vb2_queue *vq)
>>>>  {
>>>> -       struct au0828_dev    *dev = fh->dev;
>>>> +       struct au0828_dev *dev = vb2_get_drv_priv(vq);
>>>> +       struct au0828_dmaqueue *vidq = &dev->vidq;
>>>> +       unsigned long flags = 0;
>>>> +       int i;
>>>>
>>>> -       if (fh->resources & bit)
>>>> -               /* have it already allocated */
>>>> -               return 1;
>>>> +       dprintk(1, "au0828_stop_streaming called %d\n", dev->streaming_users);
>>>>
>>>> -       /* is it free? */
>>>> -       if (dev->resources & bit) {
>>>> -               /* no, someone else uses it */
>>>> -               return 0;
>>>> +       if (dev->streaming_users-- == 1)
>>>> +               au0828_uninit_isoc(dev);
>>>> +
>>>> +       spin_lock_irqsave(&dev->slock, flags);
>>>> +       if (dev->isoc_ctl.buf != NULL) {
>>>> +               vb2_buffer_done(&dev->isoc_ctl.buf->vb, VB2_BUF_STATE_ERROR);
>>>> +               dev->isoc_ctl.buf = NULL;
>>>>         }
>>>> -       /* it's free, grab it */
>>>> -       fh->resources  |= bit;
>>>> -       dev->resources |= bit;
>>>> -       dprintk(1, "res: get %d\n", bit);
>>>> +       while (!list_empty(&vidq->active)) {
>>>> +               struct au0828_buffer *buf;
>>>>
>>>> -       return 1;
>>>> -}
>>>> +               buf = list_entry(vidq->active.next, struct au0828_buffer, list);
>>>> +               vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>>>> +               list_del(&buf->list);
>>>> +       }
>>>>
>>>> -static int res_check(struct au0828_fh *fh, unsigned int bit)
>>>> -{
>>>> -       return fh->resources & bit;
>>>> -}
>>>> +       v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
>>>>
>>>> -static int res_locked(struct au0828_dev *dev, unsigned int bit)
>>>> -{
>>>> -       return dev->resources & bit;
>>>> +       for (i = 0; i < AU0828_MAX_INPUT; i++) {
>>>> +               if (AUVI_INPUT(i).audio_setup == NULL)
>>>> +                       continue;
>>>> +               (AUVI_INPUT(i).audio_setup)(dev, 0);
>>>> +       }
>>>> +       spin_unlock_irqrestore(&dev->slock, flags);
>>>> +
>>>> +       dev->vid_timeout_running = 0;
>>>> +       del_timer_sync(&dev->vid_timeout);
>>>>  }
>>>>
>>>> -static void res_free(struct au0828_fh *fh, unsigned int bits)
>>>> +void au0828_stop_vbi_streaming(struct vb2_queue *vq)
>>>>  {
>>>> -       struct au0828_dev    *dev = fh->dev;
>>>> +       struct au0828_dev *dev = vb2_get_drv_priv(vq);
>>>> +       struct au0828_dmaqueue *vbiq = &dev->vbiq;
>>>> +       unsigned long flags = 0;
>>>> +
>>>> +       dprintk(1, "au0828_stop_vbi_streaming called %d\n",
>>>> +               dev->streaming_users);
>>>> +
>>>> +       if (dev->streaming_users-- == 1)
>>>> +               au0828_uninit_isoc(dev);
>>>>
>>>> -       BUG_ON((fh->resources & bits) != bits);
>>>> +       spin_lock_irqsave(&dev->slock, flags);
>>>> +       if (dev->isoc_ctl.vbi_buf != NULL) {
>>>> +               vb2_buffer_done(&dev->isoc_ctl.vbi_buf->vb,
>>>> +                               VB2_BUF_STATE_ERROR);
>>>> +               dev->isoc_ctl.vbi_buf = NULL;
>>>> +       }
>>>> +       while (!list_empty(&vbiq->active)) {
>>>> +               struct au0828_buffer *buf;
>>>> +
>>>> +               buf = list_entry(vbiq->active.next, struct au0828_buffer, list);
>>>> +               list_del(&buf->list);
>>>> +               vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>>>> +       }
>>>> +       spin_unlock_irqrestore(&dev->slock, flags);
>>>>
>>>> -       fh->resources  &= ~bits;
>>>> -       dev->resources &= ~bits;
>>>> -       dprintk(1, "res: put %d\n", bits);
>>>> +       dev->vbi_timeout_running = 0;
>>>> +       del_timer_sync(&dev->vbi_timeout);
>>>>  }
>>>>
>>>> -static int get_ressource(struct au0828_fh *fh)
>>>> +static struct vb2_ops au0828_video_qops = {
>>>> +       .queue_setup     = queue_setup,
>>>> +       .buf_prepare     = buffer_prepare,
>>>> +       .buf_queue       = buffer_queue,
>>>> +       .start_streaming = au0828_start_analog_streaming,
>>>> +       .stop_streaming  = au0828_stop_streaming,
>>>> +       .wait_prepare    = vb2_ops_wait_prepare,
>>>> +       .wait_finish     = vb2_ops_wait_finish,
>>>> +};
>>>> +
>>>> +/* ------------------------------------------------------------------
>>>> +   V4L2 interface
>>>> +   ------------------------------------------------------------------*/
>>>> +/*
>>>> + * au0828_analog_unregister
>>>> + * unregister v4l2 devices
>>>> + */
>>>> +void au0828_analog_unregister(struct au0828_dev *dev)
>>>>  {
>>>> -       switch (fh->type) {
>>>> -       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>>>> -               return AU0828_RESOURCE_VIDEO;
>>>> -       case V4L2_BUF_TYPE_VBI_CAPTURE:
>>>> -               return AU0828_RESOURCE_VBI;
>>>> -       default:
>>>> -               BUG();
>>>> -               return 0;
>>>> -       }
>>>> +       dprintk(1, "au0828_analog_unregister called\n");
>>>> +       mutex_lock(&au0828_sysfs_lock);
>>>> +
>>>> +       if (dev->vdev)
>>>> +               video_unregister_device(dev->vdev);
>>>> +       if (dev->vbi_dev)
>>>> +               video_unregister_device(dev->vbi_dev);
>>>> +
>>>> +       mutex_unlock(&au0828_sysfs_lock);
>>>>  }
>>>>
>>>>  /* This function ensures that video frames continue to be delivered even if
>>>> @@ -950,8 +931,8 @@ static void au0828_vid_buffer_timeout(unsigned long data)
>>>>
>>>>         buf = dev->isoc_ctl.buf;
>>>>         if (buf != NULL) {
>>>> -               vid_data = videobuf_to_vmalloc(&buf->vb);
>>>> -               memset(vid_data, 0x00, buf->vb.size); /* Blank green frame */
>>>> +               vid_data = vb2_plane_vaddr(&buf->vb, 0);
>>>> +               memset(vid_data, 0x00, buf->length); /* Blank green frame */
>>>>                 buffer_filled(dev, dma_q, buf);
>>>>         }
>>>>         get_next_buf(dma_q, &buf);
>>>> @@ -974,8 +955,8 @@ static void au0828_vbi_buffer_timeout(unsigned long data)
>>>>
>>>>         buf = dev->isoc_ctl.vbi_buf;
>>>>         if (buf != NULL) {
>>>> -               vbi_data = videobuf_to_vmalloc(&buf->vb);
>>>> -               memset(vbi_data, 0x00, buf->vb.size);
>>>> +               vbi_data = vb2_plane_vaddr(&buf->vb, 0);
>>>> +               memset(vbi_data, 0x00, buf->length);
>>>>                 vbi_buffer_filled(dev, dma_q, buf);
>>>>         }
>>>>         vbi_get_next_buf(dma_q, &buf);
>>>> @@ -985,105 +966,65 @@ static void au0828_vbi_buffer_timeout(unsigned long data)
>>>>         spin_unlock_irqrestore(&dev->slock, flags);
>>>>  }
>>>>
>>>> -
>>>>  static int au0828_v4l2_open(struct file *filp)
>>>>  {
>>>> -       int ret = 0;
>>>> -       struct video_device *vdev = video_devdata(filp);
>>>>         struct au0828_dev *dev = video_drvdata(filp);
>>>> -       struct au0828_fh *fh;
>>>> -       int type;
>>>> -
>>>> -       switch (vdev->vfl_type) {
>>>> -       case VFL_TYPE_GRABBER:
>>>> -               type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>>> -               break;
>>>> -       case VFL_TYPE_VBI:
>>>> -               type = V4L2_BUF_TYPE_VBI_CAPTURE;
>>>> -               break;
>>>> -       default:
>>>> -               return -EINVAL;
>>>> -       }
>>>> -
>>>> -       fh = kzalloc(sizeof(struct au0828_fh), GFP_KERNEL);
>>>> -       if (NULL == fh) {
>>>> -               dprintk(1, "Failed allocate au0828_fh struct!\n");
>>>> -               return -ENOMEM;
>>>> -       }
>>>> +       int ret = 0;
>>>>
>>> No need to assign it to zero.
>>
>> Yes. Looks like there are a few other routines that zero out
>> ret. If you want to see all of those cleaned up, I can do a
>> separate patch cleaning all these instances. If not I can send
>> patch v4? Please let me know your preference.
>>
> No it needs to go in this patch itself for here.

No problem. I will send patch v4 for this patch with this change.

> 
>>>
>>>> -       fh->type = type;
>>>> -       fh->dev = dev;
>>>> -       v4l2_fh_init(&fh->fh, vdev);
>>>> -       filp->private_data = fh;
>>>> +       dprintk(1,
>>>> +               "%s called std_set %d dev_state %d stream users %d users %d\n",
>>>> +               __func__, dev->std_set_in_tuner_core, dev->dev_state,
>>>> +               dev->streaming_users, dev->users);
>>>>
>>>> -       if (mutex_lock_interruptible(&dev->lock)) {
>>>> -               kfree(fh);
>>>> +       if (mutex_lock_interruptible(&dev->lock))
>>>>                 return -ERESTARTSYS;
>>>> +
>>>> +       ret = v4l2_fh_open(filp);
>>>> +       if (ret) {
>>>> +               au0828_isocdbg("%s: v4l2_fh_open() returned error %d\n",
>>>> +                               __func__, ret);
>>>> +               mutex_unlock(&dev->lock);
>>>> +               return ret;
>>>>         }
>>>> +
>>>>         if (dev->users == 0) {
>>>
>>> you can use v4l2_fh_is_singular_file() and get rid of users member ?
>>
>> Please see Devin's response on this. I have been debugging the change
>> I made to use v4l2_fh_is_singular_file() instead of users and seeing
>> problem with reset stream and couldn't really figure out why until
>> Devin explained it.
>>
> Agreed.

Thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
