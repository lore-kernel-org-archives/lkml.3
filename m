Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbaHZVbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:31:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbaHZVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:31:51 -0400
Date: Tue, 26 Aug 2014 14:31:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: a.zummo@towertech.it, kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCHv2 1/5] rtc: s3c: Define s3c_rtc structure to remove
 global variables.
Message-Id: <20140826143149.7cd3ab27b6247a59a486e681@linux-foundation.org>
In-Reply-To: <53FA89FD.1030004@samsung.com>
References: <y@samsung.com>
	<1407808871-6046-1-git-send-email-y@samsung.com>
	<1407808871-6046-2-git-send-email-y@samsung.com>
	<20140822134204.1fa5be7aeb76a50b45ccc5f5@linux-foundation.org>
	<53FA89FD.1030004@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2014 09:57:33 +0900 Chanwoo Choi <cw00.choi@samsung.com> wrote:

> Dear Andrew, 
> 
> On 08/23/2014 05:42 AM, Andrew Morton wrote:
> > On Tue, 12 Aug 2014 11:01:07 +0900 y@samsung.com wrote:
> > 
> >> This patch define s3c_rtc structure including necessary variables for S3C RTC
> >> device instead of global variables. This patch improves the readability by
> >> removing global variables.
> > 
> > Below is the v1->v2 delta.
> > 
> > Why were all those tests of info->base added?  Can it really be zero? 
> > I don't see how.
> 
> If some functions (e.g., s3c_rtc_settime) accesses the rtc register
> by using info->base before the initialization of info->base in s3c_rtc_probe,
> I thought that null pointer error would happen.

probe() should be called before anything else.  If we're somehow
calling s3c_rtc_settime() before probe() has completed then something
very bad is happening - for example, the device may have been
registered far too early.  But I don't think that's the case here.

That being said, it does seem strange that s3c_rtc_probe() calls
devm_rtc_device_register() *before* trying to request its IRQs.  So if
IRQ requesting fails, we go and immediately unregister the device. 
Some other drivers do it this way, others do not.  Wouldn't it be
better to defer registration until we know that all the probe() setup
operations have succeeded?

> But, I missed one point which info->base might have the garbate data instead of NULL.
> I'll add the initialization code for info->base.
> 	info->base = NULL;
> 
> If you don't agree it, I'll drop this code checking the state of info->base on next patchset(v3).

Well, we should have those checks in there unless we know they're
needed.  And if they *are* needed, we should have a good understanding
of why they're needed, and we should be sure that we're not just
working around some underlying problem.

