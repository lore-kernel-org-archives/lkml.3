Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3KYISD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:18:03 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:57172 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3KYISA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:18:00 -0500
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: Vivek Goyal <vgoyal@redhat.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: "bhe@redhat.com" <bhe@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "chaowang@redhat.com" <chaowang@redhat.com>
Subject: Re: /proc/vmcore mmap() failure issue
Thread-Topic: /proc/vmcore mmap() failure issue
Thread-Index: AQHO5toV18hsX/7760SqeZbh92xDy5o1m10w
Date: Mon, 25 Nov 2013 08:10:10 +0000
Message-ID: <0910DD04CBD6DE4193FCF86B9C00BE971C5AB3@BPXM01GP.gisp.nec.co.jp>
References: <5284A689.70903@jp.fujitsu.com>
 <20131114151359.GA3913@redhat.com> <5285EC60.1060906@jp.fujitsu.com>
 <20131115142617.GC6637@redhat.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971BF592@BPXM01GP.gisp.nec.co.jp>
 <20131118135511.GA30637@redhat.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971C3862@BPXM01GP.gisp.nec.co.jp>
 <20131120145901.GB27924@redhat.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971C43E3@BPXM01GP.gisp.nec.co.jp>
 <528DC4F2.5040000@jp.fujitsu.com> <20131121165237.GG16208@redhat.com>
In-Reply-To: <20131121165237.GG16208@redhat.com>
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

On 2013/11/22 1:53:14, kexec <kexec-bounces@lists.infradead.org> wrote:
> On Thu, Nov 21, 2013 at 05:31:46PM +0900, HATAYAMA Daisuke wrote:
> 
> [..]
> > > So I think the patch I sent is enough, the policy will be simpler as
> > > "Don't use mmap() for buggy kernels".
> > > 
> > > [PATCH] Fall back to read() when mmap() fails.
> > > http://lists.infradead.org/pipermail/kexec/2013-November/010199.html
> > > 
> > 
> > I think logic becomes not so complex. For example, if input vmcore
> > format is ELF, then:
> > 
> > o in update_mmap_range():
> >   - first calculate a range of the corresponding PT_LOAD entry truncated with
> >     PAGE_SIZE.
> >   - Then, truncate range of mmap() by the truncated range of the corresponding
> >     PT_LOAD entry, i.e., exlucde partial pages from mmap() target range.
> >   - Then determine offsets of two partial pages; the number of partial pages
> >     are always at most two. The offsets can easily be calculated from the
> >     original range of the corresponding PT_LOAD entry
> > 
> > o in read_from_vmcore(), if a given offset belongs to either of two partial
> >   pages, then go to read() path; if not, go to mmap() path.
> 
> I agree that we should do mmap() on all non-partial pages and do read()
> on all partial pages. Otherwise we lose the benefit of faster speed of
> mmap().

I agree to avoid this issue by fixing makedumpfile as workaround while to
fix kernel is so tough and risky. However, it sounds strange to me to fix
userspace side elaborately for such definite kernel issue whose cause is
known, so we should fix the kernel itself.

Otherwise, will you continue to add specific fixes into user tools to
address kernel issues like this case ?


Thanks
Atsushi Kumagai

> Thanks
> Vivek
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
