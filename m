Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaKQUjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:39:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbaKQUjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:39:05 -0500
Date: Mon, 17 Nov 2014 15:38:30 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ptesarik@suse.cz, kumagai-atsushi@mxc.nes.nec.co.jp, anderson@redhat.com,
        kexec@lists.infradead.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in
 VMCOREINFO
Message-ID: <20141117203830.GD17152@redhat.com>
References: <20141113090657.2578f087@hananiah.suse.cz>
 <54646C1D.1050102@jp.fujitsu.com>
 <20141113142548.GA1978@redhat.com>
 <20141114.103133.364422370204110382.d.hatayama@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114.103133.364422370204110382.d.hatayama@jp.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 10:31:33AM +0900, HATAYAMA Daisuke wrote:
> From: Vivek Goyal <vgoyal@redhat.com>
> Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in VMCOREINFO
> Date: Thu, 13 Nov 2014 09:25:48 -0500
> 
> > On Thu, Nov 13, 2014 at 05:30:21PM +0900, HATAYAMA, Daisuke wrote:
> >> 
> >> 
> >> (2014/11/13 17:06), Petr Tesarik wrote:
> >> >On Thu, 13 Nov 2014 09:17:09 +0900 (JST)
> >> >HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
> >> >
> >> >>From: Vivek Goyal <vgoyal@redhat.com>
> >> >>Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in VMCOREINFO
> >> >>Date: Wed, 12 Nov 2014 17:12:05 -0500
> >> >>
> >> >>>On Wed, Nov 12, 2014 at 03:40:42PM +0900, HATAYAMA Daisuke wrote:
> >> >>>>Currently, VMCOREINFO note information reports the virtual address of
> >> >>>>phys_base that is assigned to symbol phys_base. But this doesn't make
> >> >>>>sense because to refer to value of the phys_base, it's necessary to
> >> >>>>get the value of phys_base itself we are now about to refer to.
> >> >>>>
> >> >>>
> >> >>>Hi Hatayama,
> >> >>>
> >> >>>/proc/vmcore ELF headers have virtual address information and using
> >> >>>that you should be able to read actual value of phys_base. gdb deals
> >> >>>with virtual addresses all the time and can read value of any symbol
> >> >>>using those headers.
> >> >>>
> >> >>>So I am not sure what's the need for exporting actual value of
> >> >>>phys_base.
> >> >>>
> >> >>
> >> >>Sorry, my logic in the patch description was wrong. For /proc/vmcore,
> >> >>there's enough information for makedumpdile to get phys_base. It's
> >> >>correct. The problem here is that other crash dump mechanisms that run
> >> >>outside Linux kernel independently don't have information to get
> >> >>phys_base.
> >> >
> >> >Yes, but these mechanisms won't be able to read VMCOREINFO either, will
> >> >they?
> >> >
> >> 
> >> I don't intend such sophisticated function only by VMCOREINFO.
> >> Search vmcore for VMCOREINFO using strings + grep before opening it by crash.
> >> I intend that only here.
> > 
> > I think this is very crude and not proper way to get to vmcoreinfo. Can
> 
> I agree it's crude, but it's useful enough for my usecase.
> 
> > you give more context. What are those mechanisms and what are you trying
> > to do.
> > 
> 
> I after all write the same thing in the patch description... I mean
> qemu dump, xendump (and other hypervisor dumps), firmware dumps
> implemented on each vendor system for the crash dump mechanism.

vmcoreinfo is exported by kdump mechanism (/proc/vmcore). These other
dump mechanism needs to figure a way out how to export relevant
information and it is not right to try to put more info in vmcoreinfo.

Don't try to write kernel data structures in such a way so that
somebody can scan these later. In an external dump mechanism there
is no notion of vmcoreinfo elf header. So these mechanisms need to
come up with their own way to query some basic information about
kernel and export appropriately.

Also this notion of relying on two mechanism is unnecessary 
introducing extra complexity. I think you should provide user
a choice so that they can configure one or other. If you think
that firmware dump mechanisms are more reliable, just use these.
In fact when crash happens then OS should call into some
firmware hook to trigger dump. And along that hook one should
be able to pass relevant info.

Thanks
Vivek
