Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaAJOVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:21:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaAJOVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:21:15 -0500
Date: Fri, 10 Jan 2014 06:21:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Intel MIC host driver: possible signed underflow (undefined
 behavior) in userspace API
Message-ID: <20140110142116.GB7212@kroah.com>
References: <1151498255.5788.1389332631491.JavaMail.zimbra@efficios.com>
 <1593870977.5807.1389333385962.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1593870977.5807.1389333385962.JavaMail.zimbra@efficios.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 05:56:25AM +0000, Mathieu Desnoyers wrote:
> Hi,
> 
> Looking at this commit:
> 
> commit f69bcbf3b4c4b333dcd7a48eaf868bf0c88edab5
> Author: Ashutosh Dixit <ashutosh.dixit@intel.com>
> Date:   Thu Sep 5 16:42:18 2013 -0700
> 
>     Intel MIC Host Driver Changes for Virtio Devices.
> 
> Especially at:
> 
> +struct mic_copy_desc {
> +#ifdef __KERNEL__
> +       struct iovec __user *iov;
> +#else
> +       struct iovec *iov;
> +#endif
> +       int iovcnt;
> +       __u8 vr_idx;
> +       __u8 update_used;
> +       __u32 out_len;
> +};
> 
> Seeing iovcnt being declared as a signed integer seems strange. The
> first question would be: why is it signed rather than unsigned ?
> 
> Then, looking further into 
> 
> drivers/misc/mic/host/mic_virtio.c:_mic_virtio_copy()
> 
> We can see that the while() loop iterates until the local variable
> iovcnt reaches the value 0 (and iovcnt is also a signed integer). If
> user-space passes e.g. INT_MIN as iovcnt field, this loop then appears
> to depend on an undefined behavior (signed underflow) to complete.
> Wouldn't it be better to use an unsigned integers both in the
> userspace API and for the local variable ?

Better yet, it should be a "__" type variable, as "int" doesn't mean
much when crossing the user/kernel boundry...

thanks,

greg k-h
