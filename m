Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab3KDOjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 09:39:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab3KDOja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 09:39:30 -0500
Date: Mon, 4 Nov 2013 22:38:50 +0800
From: WANG Chao <chaowang@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, kdump: crashkernel=X try to reserve below 896M
 first, then try below 4G, then MAXMEM
Message-ID: <20131104143850.GA10446@dhcp16-109.nay.redhat.com>
References: <CAE9FiQWdMmSseDk6J=TOXT9ZahJUBf2BOU+VHJRXeeMofgH=EQ@mail.gmail.com>
 <20131021151643.GA20669@redhat.com>
 <CAE9FiQVfeUdugFRMt1DGjtqW2FAb2gfnGjXENHjoJ=JVAYbYgw@mail.gmail.com>
 <20131024140241.GA2322@redhat.com>
 <CAE9FiQUu0WwMgNpog4TKch+MT2i7_DsNvqZxbyQusS4AFxdhQQ@mail.gmail.com>
 <20131024191821.GE2322@redhat.com>
 <CAE9FiQU7+FRY=3ETdGZJJfcS0vjRht4ZT8MHTQ66kpjD2MmrcA@mail.gmail.com>
 <20131024192752.GG2322@redhat.com>
 <CAE9FiQUw6REg2TXnSXtNZK8XY9vnorvi8oDbUn_5WdNZ6yiRtQ@mail.gmail.com>
 <20131028151224.GB1659@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028151224.GB1659@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 at 11:12am, Vivek Goyal wrote:
> On Thu, Oct 24, 2013 at 10:48:29PM -0700, Yinghai Lu wrote:
> > On Thu, Oct 24, 2013 at 12:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > On Thu, Oct 24, 2013 at 12:24:57PM -0700, Yinghai Lu wrote:
> > >> On Thu, Oct 24, 2013 at 12:18 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > >> > On Thu, Oct 24, 2013 at 12:15:25PM -0700, Yinghai Lu wrote:
> > >> >
> > >> > Also keeping things simple by not trying to *impose* a new crashkernel=
> > >> > syntax on existing crashkernel=xM users.
> > >>
> > >> Existing user that have crashkernel=xM working with their old kernel
> > >> and old kexec-tools, they still could keep their old command line and
> > >> old kexec-tools
> > >> with new updated kernel.
> > >> We should not change semantics to surprise them.
> > >
> > > Old users will get reservation still below 896MB.
> > >
> > > It will go above 896MB only if memory could not be allocated below 896MB.
> > >
> > > In the past reservation will fail and kexec-tools will fail.
> > > Now reservation will succeed but kexec-tools will fail.
> > >
> > > So end result a user sees is that kexec-tools fails. So I don't see how
> > > we are breaking existing installations or user setups.
> > 
> > case could be: if user add more memory and put more pcie cards, and
> > second kernel will need more ram and OOM there.
> 
> Now makedumpfile supports cyclic mode by default. So one does not have
> to necessarily linearly scale reserved memory based on physical memory
> present in the box.
> 
> > so user could just increase crashkernel=512M to crashkernel=1G.
> 
> If user has new makedumpfile, OOM should not happen and one should not
> have to increase memory reservation.
> 
> > 
> > without Cong's patch, kernel will fail to reserve, and user would dig
> > to change it
> > to crashkernel=1G,high, and update kexec-tools.
> > 
> > with Cong's patch, kernel will reserve other range like between 896
> > and 4G, old kexec-tools either
> > fail to load second kernel or hang in purgatory or early stage of
> > second kernel, or other unknown behavior.
> 
> I understand your concern about memory being reserved high and kexec
> just hanging. Only thing I am arguing is that the number of cases where
> it will happen is small.
> 
> - First of all for all old existing kexec-tools memory will stil come
>   from 896MB.
> - Old kexec-tools enforced that purgatory is loaded below 2G. So if 
>   memory is reserved above 2G, kexec-tools will fail.
> 
> So only problematic case seems to be that if user increased crashkernel=X
> value and memory got reserved between 896M and 2G. But this is not same
> as breaking old setups as old setups anyway never worked with this 
> configuration.
> 
> You argument that user will research and upgrade kexec-tools and use
> crashkernel=X,high, then it holds true for the case where memory is
> reserved between 896M and 2G.
> 
> I personally think that it is easier for a user to not change any
> kernel parameters with kernel and kexec-tools upgrade and still be
> able to work with large memory systems. So the benefit of extending
> the semantics of existing parameter seems to be outweighing the downside
> of side, IMHO.
> 
> > 
> > I would think first path is much clear and predicted.
> > 
> > If my memory is right, HPA did not like idea that we try below 896M,
> > and then under 4G and then above 4G.
> 
> hpa, I know you did not like the idea in the past. Is it still the case.

Hi, hpa

Do you still not like this idea? Could you make it more clear to us
please?

Thanks
Chao

> 
> IMHO, I like the fact that existing users still be able to work with
> crashkernel=X and not forced to switch to crashkernel=x,high and also incur
> the penalty of reserving extra memory for software iotlb.
> 
> Thanks
> Vivek
