Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3CLNrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:47:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab3CLNrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:47:05 -0400
Date: Tue, 12 Mar 2013 09:46:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130312134658.GB4671@redhat.com>
References: <CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com>
 <20130311192021.GF12107@redhat.com>
 <513E36CB.5040908@zytor.com>
 <20130311201245.GC14738@redhat.com>
 <513E3C44.9030402@zytor.com>
 <87hakhk6xu.fsf@xmission.com>
 <20130311204530.GE14738@redhat.com>
 <513E438D.5010303@zytor.com>
 <20130311210333.GF14738@redhat.com>
 <513E4771.8070203@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513E4771.8070203@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 02:06:57PM -0700, H. Peter Anvin wrote:
> On 03/11/2013 02:03 PM, Vivek Goyal wrote:
> >>
> >> And the solution to that isn't obvious?
> > 
> > Sorry, I did not understand what do you mean by above.
> > 
> > If you are suggesting that move away from dracut, it does not work
> > in practice. Initially we wrote our custom code to generate custom
> > initramfs, and we were always lagging in terms of what dump targets
> > can be supported and kept on constantly fixing the issues which had
> > been taken care of in dracut one way or other. So it was like
> > maintaining a duplicate initramfs generation tool.
> > 
> > So we do not want to use non-standard tools just for kdump. dracut
> > generates the initramfs for first kernel and then it should be able
> > to for second kernel too.
> > 
> > Another problem is that other user space component developers, they don't
> > know that they are supposed to work with 64MB in total too. Same is true for
> > anybody who is writing driver code. 
> > 
> > And bloated memory usage is detected, after the fact. After that one
> > can keep on chasing people, and they say that it is their feature
> > requirement. And it is not possible to go and optimize every subsystem
> > so that together they can boot and work with 64MB.
> > 
> 
> Your problem is fundamentally that you are using the wrong tool for the
> job, simply because it is expedient to you.  Arguably dracut & co are
> the wrong tool for any job given the enormous amount of bloat it
> entails, but at least in the normal kernel case it only affects boot
> time as it is jettisoned, but in your case it is not.

Dracut is just one piece of the puzzle. We are optimizing away dracut
for kdump environment. We generate host only initramfs and using command
line options actively exclude the components which we don't need when
generating kdump initramfs.

But as kdump usage grows, customers want more out of kdump both in
terms of features and performance. For example, now we support dumping
to multipath over iscsi targets. For this target we first pack relevant
networking drivers and networking utilities, then pack in iscsi related
utiilties, then all the multipath related components go in and on top of
that all the lvm related utilities and components and dependent libraries
go in. And inclusion of more components leads to memory bloat.

I do agree with the optimization part though. That is include minimal
set of components and be vigilant about memory usage of various
components.

One of the things which could help is if we had a way to track module
memory usage. May be some /sys interface which could export how much
memory module is using. We could use that as debug output and
over a period of time we could figure out how module memory usage is
growing and who are worst offenders and where are the optimization
opportunities.

Thanks
Vivek
