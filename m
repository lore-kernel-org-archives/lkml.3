Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab3JXLCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 07:02:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab3JXLB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 07:01:58 -0400
Date: Thu, 24 Oct 2013 19:01:17 +0800
From: WANG Chao <chaowang@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, kdump: crashkernel=X try to reserve below 896M
 first, then try below 4G, then MAXMEM
Message-ID: <20131024110117.GB3033@dhcp16-109.nay.redhat.com>
References: <1381751200-27376-1-git-send-email-chaowang@redhat.com>
 <CAE9FiQUNMDuVZtqud3LBbAmE0SL8ZWLFnc+CSYZm4UfTvNUaOA@mail.gmail.com>
 <20131015144810.GI31215@redhat.com>
 <CAE9FiQXVCx__SuhAdO9_CNaRncW2HB2tv3UjZrQcbsTV35QWow@mail.gmail.com>
 <20131018123837.GB2277@redhat.com>
 <CAE9FiQWdMmSseDk6J=TOXT9ZahJUBf2BOU+VHJRXeeMofgH=EQ@mail.gmail.com>
 <20131021151643.GA20669@redhat.com>
 <CAE9FiQVfeUdugFRMt1DGjtqW2FAb2gfnGjXENHjoJ=JVAYbYgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVfeUdugFRMt1DGjtqW2FAb2gfnGjXENHjoJ=JVAYbYgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/13 at 11:11pm, Yinghai Lu wrote:
> On Mon, Oct 21, 2013 at 8:16 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Oct 18, 2013 at 10:45:43PM -0700, Yinghai Lu wrote:
> >
> >
> > IIUC, you are trying to say that with new kernel old kexec-tools will fail
> > at a different failure point. I don't see why that is a problem. It still
> > fails.
> 
> Yes, that could cause confusion.
> 
> We already knew it would fail possible at most later, we should make
> it skip allocation during first kernel booting.

It's said:

	crashkernel=size[KMG][@offset[KMG]]
			[KNL] Using kexec, Linux can switch to a 'crash kernel'
			upon panic. This parameter reserves the physical
			memory region [offset, offset + size] for that kernel
			image. If '@offset' is omitted, then a suitable offset
			is selected automatically. Check
			Documentation/kdump/kdump.txt for further details.

Nothing mentions that crashkernel=X is restricted to reserve at low.

It could be more confusing that crashkernel=X (say 1G) can not find a
suitable area while actually there's enough memory out there.

Current situation is the combination of crashkernel X/high/low is quite
complicated, it's more like supposed to be used by the pros.

Truth is, most user, after upgrading to new kernel, would want reserve
large by just changing to crashkernel=1G, not be forced to use a new
format craskernel=1G,high.

I think crashkernel=XM,high is really supposed to be used when user indeed
want to reserve from high.

Like Vivek said, failing at different point shouldn't be a problem.
That's an incorrect configuration. When crashkernel=1G,high, old
kexec-tools still fails the same way. That could cause confusion, in
your word.

Let me put it in an example, a user want to utilize this new kernel
feature to reserve 1G for crash kernel but not upgrade kexec-tools,

- W/o this patch:
 First he would try crashkernel=1G, but failed to reserve. Second time,
 he goes with crashkernel=1G,high, reservation is fine but kexec fails
 to load. Upgrading kexec-tools is essential to him.

- W/ this patch:
  First he would try crashkernel=1G, reservation is ok but kexec fails
  to load the same way as the case of crashkernel=1G,high. Upgrading
  kexec-tools is essential to him.

The point is old kexec-tools can't load high, no matter by what kind of
crashkernel cmdline to reserve at high.

> 
> >
> > [..]
> >> > You are not thinking about ease of use here for existing users.
> >>
> >> most existing user don't need to do anything. just with new kernel and
> >> old kexec tools.
> >>
> >> those system that did not work kexec before because XM is too big, they have to
> >> update kexec tools, and use ",high"
> >>
> >> Make it simple, less error.
> >
> > No, it is not that simple. Think from a distribution's perspective also.
> > We have the logic to scale reserved memory based on physical memory
> > present in the system. Now we are seeing bigger memory systems (which
> > would not have worked in the past). We still want to retain the existing
> > logic and not switch to crashkernel=x,high. One does not have to. It
> > makes life simpler.
> 
> distribution should go with ",high" for 64 bit kernel and new kexec-tools.
> for 32bit kernel, you still can have ",high" or not, as ",high" is ignored.

Why ",high" is becoming a default one instead of "XM"?

Isn't that the kernel's job to find a most suitable area at best guess
in this case? By this case, I mean kernel have no idea kexec-tools is
new or old.

> 
> 
> >
> > Same logic working both with smaller memory systems as well as large memory
> > systems. One should not have to choose a different command line because
> > there is more physical RAM present in the system.
> 
> ",high" is working even on smaller memory sytem.

Yeah, you're right.

> 
> >
> >>
> >> We already support above 4G, what is point for trying below 4G?
> >
> > Because it is not *required* to reserve memory above 4G. Because we want
> > same command line to work with both small memory systems as well as
> > large memory systems and we don't care whether memory is reserved below
> > 4G or above 4G. What does matter though that we don't have to worry about
> > switching command line option if it is large memory system.
> 
> ",high" will work smaller or large memory system after you install new
> kexec tools.
> 
> Again, for distribution, when new kernel is added, new kernel will all
> have ",high"
> and new kexec-tools get installed.
> 
> Even we want to extend crashkernel=XM, then i would like to have
> it identical to crashkernel=XM,high instead.

Why would you like crashkernel=XM is identical to crashkernel=XM,high?

That's not an option if you want new kernel to be compatible with old
kexec-tools.


Thanks
WANG Chao
