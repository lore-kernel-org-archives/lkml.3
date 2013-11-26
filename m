Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3KZB6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:58:17 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:48615 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3KZB6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:58:16 -0500
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: "bhe@redhat.com" <bhe@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "chaowang@redhat.com" <chaowang@redhat.com>
Subject: Re: /proc/vmcore mmap() failure issue
Thread-Topic: /proc/vmcore mmap() failure issue
Thread-Index: AQHO5Q1z18hsX/7760SqeZbh92xDy5otk3zQ//+DOgCACatYwA==
Date: Tue, 26 Nov 2013 01:52:10 +0000
Message-ID: <0910DD04CBD6DE4193FCF86B9C00BE971C5FB3@BPXM01GP.gisp.nec.co.jp>
References: <20131113204130.GD7613@redhat.com>
 <5284A689.70903@jp.fujitsu.com> <20131114151359.GA3913@redhat.com>
 <5285EC60.1060906@jp.fujitsu.com> <20131115142617.GC6637@redhat.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971BF592@BPXM01GP.gisp.nec.co.jp>
 <528B3585.5080606@jp.fujitsu.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971C3845@BPXM01GP.gisp.nec.co.jp>
 <528C5A1C.3040103@jp.fujitsu.com>
In-Reply-To: <528C5A1C.3040103@jp.fujitsu.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.21.40.240]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/11/20 15:44:45, kexec <kexec-bounces@lists.infradead.org> wrote:
> (2013/11/20 14:27), Atsushi Kumagai wrote:
> > On 2013/11/19 18:56:21, kexec <kexec-bounces@lists.infradead.org> wrote:
> >> (2013/11/18 9:51), Atsushi Kumagai wrote:
> >>> (2013/11/15 23:26), Vivek Goyal wrote:
> >>>> On Fri, Nov 15, 2013 at 06:41:52PM +0900, HATAYAMA Daisuke wrote:
> >>>>
> >>>> [..]
> >>>>>> Given the fact that hpa does not like fixing it in kernel. We are
> >>>>>> left with option of fixing it in following places.
> >>>>>>
> >>>>>> - Drop partial pages in kexec-tools
> >>>>>> - Drop partial pages in makeudmpfile.
> >>>>>> - Read partial pages using read() interface in makedumpfile
> >>>>>> - Modify /proc/vmcore to copy partial pages in second kernel's memory.
> >>>>>>
> >>>>>> It is not clear to me that partial pages are really useful.  So I
> >>>>>> want to avoid modifying /proc/vmcore to deal with partial pages and
> >>>>>> increase complexity.
> >>>>>>
> >>>>>> So fixing makedumpfile (either option2 or option 3) seems least
> >>>>>> risky to me. In fact I would say let us keep it simple and truncate
> >>>>>> partial pages in makedumpfile to keep it simple. And look at option
> >>>>>> 3 once we have a strong use case for partial pages.
> >>>>>>
> >>>>>> What do you think?
> >>>>>>
> >>>>>
> >>>>> As you say, it's not clear that partial pages are really useful, but
> >>>>> on the other hand, it seems to me not clear that they are really useless.
> >>>>> I think we should get them as long as we have access to them.
> >>>>>
> >>>>> It seems best to me the option 3). Switching between read and mmap
> >>>>> would be not so complex and also it's by far flexible in
> >>>>> makedumpfile than in kernel.
> >>>>
> >>>> Ok, I am fine with option 3. It is more complicated option but safe
> >>>> option.
> >>>
> >>> It sounds reasonable also to me.
> >>>
> >>>> Is there any chance that you could look into fixing this. I have no
> >>>> experience writing code for makedumpfile.
> >>>
> >>> I'll send a patch to fix this soon.
> >>>
> >>
> >> Thanks.
> >>
> >> BTW, now the following patch has been applied on top of makedumpfile in kexec-tools package on fedora in order to avoid the issue.
> >>
> >> https://lists.fedoraproject.org/pipermail/kexec/2013-November/000254.html
> >>
> >> I remember prototype version of mmap patch implemented a kind of --no-mmap option and we could use it to disable mmap() use and use read() instead, I think which is useful when we face this kind of issue.
> > 
> > How about this fail back structure instead of such an extra option ?
> > 
> 
> I think this logic is useful and should be merged together in this fix.
> 
> However, I still think a kind of --no-mmap option is needed. There could happen
> worse case due to mmap() in the future on some system, of course, I don't know
> what the system actually is, but at least it must be behaving differently from
> typical systems... Then, option is more flexible than patching.
> 
> It would also be useful for debugging use. read() is simpler than mmap(), and
> read() is basic in the sense that initially makedumpfile didn't use mmap().
> There might be a situation where we want to avoid using mmap(); for example,
> when makedumpfile works badly and it looks like caused by mmap() code in kernel
> code; Then, we would want to see if makedumpfile works well by disabling mmap(), 

Thanks for your explanation.
Additionally, the option to disable mmap() manually will help my test,
so I should introduce the option into upstream. 


Thanks
Atsushi Kumagai

> -- 
> Thanks.
> HATAYAMA, Daisuke
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
