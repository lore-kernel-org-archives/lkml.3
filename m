Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3IKQaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:30:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44007 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab3IKQaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:30:03 -0400
Date: Wed, 11 Sep 2013 09:29:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Christoph Hellwig <hch@infradead.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and
 XTENSA
Message-ID: <20130911162955.GA1103@infradead.org>
References: <20130909015945.GA4029@kroah.com>
 <522D3153.5000102@roeck-us.net>
 <20130909023152.GA5329@kroah.com>
 <522D32F6.4020705@roeck-us.net>
 <20130909050147.GA3899@osiris>
 <CA+a=Yy6h0y=J9-NQ6LQ8fkWxqQnTQKxAt2+Pr3fSwLQ1hefGsw@mail.gmail.com>
 <20130911014443.GA20996@infradead.org>
 <CA+a=Yy6GFzoBT0Bgz7z5bHZRMdEBJa+txwpCZuxA+mRTch-8mA@mail.gmail.com>
 <20130911023026.GA6273@roeck-us.net>
 <CA+a=Yy7+cj4Bw_4PArxMo2Manqp+aTVUi-7UcS+6-qNv7-RPyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+a=Yy7+cj4Bw_4PArxMo2Manqp+aTVUi-7UcS+6-qNv7-RPyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 10:51:50AM +0800, Peng Tao wrote:
> I'm not fighting against removing the piece of code. But if there is a
> strong reason to keep the functionality, we need to find a way to
> implement it. The convenience of using environment variables is that
> job scheduler can set the environment and other existing applications
> don't have to change. Are there other means to do the same? ioctl and
> upcall both need application change AFAIK.

There is no use case for it, the kernel has no business looking at these
variables.  Given that you think it's not even used I don't even know
why we're having this discussion.

Talking about nasty code, the whole linux-curproc.c is highly
questionable:

 - cfs_curproc_groups_nr:
   	unused and should be removed

 - cfs_cap_raise/cfs_cap_lower/cfs_cap_raised:
   	needs to go away, modyules must not change access permissions
	on behalf of processes

 - the whole cfs_cap_t handling also needs to go away, passing around
   capabilities is not a concept the kernel supports for a reason

 - current_is_32bit:
	Code should just use is_compat_task directly.


I've just taken the time to walk through this one file, but it seems
like most of libcfs is just as bad.
