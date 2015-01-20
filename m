Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbbATQgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:36:36 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:51375 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbbATQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:36:34 -0500
Date: Tue, 20 Jan 2015 16:36:22 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 2/7] mfd: cros_ec: Add char dev and virtual dev
 pointers
Message-ID: <20150120163622.GD30656@x1>
References: <1420205572-2640-1-git-send-email-javier.martinez@collabora.co.uk>
 <1420205572-2640-3-git-send-email-javier.martinez@collabora.co.uk>
 <20150120075011.GS21886@x1>
 <54BE770D.6030806@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BE770D.6030806@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Javier Martinez Canillas wrote:

> Hello Lee,
> 
> Thanks a lot for your feedback.
> 
> On 01/20/2015 08:50 AM, Lee Jones wrote:
> >> @@ -59,9 +60,17 @@ struct cros_ec_command {
> >>   *
> >>   * @ec_name: name of EC device (e.g. 'chromeos-ec')
> >>   * @phys_name: name of physical comms layer (e.g. 'i2c-4')
> >> - * @dev: Device pointer
> >> + * @dev: Device pointer for physical comms device
> >> + * @vdev: Device pointer for virtual comms device
> >> + * @cdev: Character device structure for virtual comms device
> >>   * @was_wake_device: true if this device was set to wake the system from
> >>   * sleep at the last suspend
> >> + * @cmd_readmem: direct read of the EC memory-mapped region, if supported
> >> + *     @offset is within EC_LPC_ADDR_MEMMAP region.
> >> + *     @bytes: number of bytes to read. zero means "read a string" (including
> >> + *     the trailing '\0'). At most only EC_MEMMAP_SIZE bytes can be read.
> >> + *     Caller must ensure that the buffer is large enough for the result when
> >> + *     reading a string.
> >>   *
> >>   * @priv: Private data
> >>   * @irq: Interrupt to use
> >> @@ -90,8 +99,12 @@ struct cros_ec_device {
> >>  	const char *ec_name;
> >>  	const char *phys_name;
> >>  	struct device *dev;
> >> +	struct device *vdev;
> >> +	struct cdev cdev;
> >>  	bool was_wake_device;
> >>  	struct class *cros_class;
> >> +	int (*cmd_readmem)(struct cros_ec_device *ec, unsigned int offset,
> >> +			   unsigned int bytes, void *dest);
> > 
> > Is this safe?  Are you sure it's okay to provide an interface from
> > userspace to read (kernel?) memory?
> >
> 
> This interface is not to read any kernel memory but only the memory mapped
> I/O region for the Low Pin Count (LPC) bus. So user-space only can choose
> and offset and a number of bytes using the CROS_EC_DEV_IOCRDMEM ioctl cmd
> which uses the following structure as argument:
> 
> /*
>  * @offset: within EC_LPC_ADDR_MEMMAP region
>  * @bytes: number of bytes to read. zero means "read a string" (including '\0')
>  *         (at most only EC_MEMMAP_SIZE bytes can be read)
>  * @buffer: where to store the result
>  * ioctl returns the number of bytes read, negative on error
>  */
> struct cros_ec_readmem {
>         uint32_t offset;
>         uint32_t bytes;
>         uint8_t buffer[EC_MEMMAP_SIZE];
> };
> 
> The cros_ec_lpc_readmem() handler that the function pointer is set only
> reads bytes from EC_LPC_ADDR_MEMMAP + offset if offset < EC_MEMMAP_SIZE
> and the data is copied to the user-space buffer from the structure passed
> as argument with copy_to_user().
> 
> So in that sense is similar to the spidev or i2c-dev interfaces that are
> used to access these buses from user-space.

Very well.  The purpose of my question was to be provocative and to
make you think about the interface.  As long as you're sure it can't
be abused, then I'm happy.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
