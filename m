Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423028Ab3FUOYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:24:22 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45053 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422910Ab3FUOYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:24:21 -0400
Date: Fri, 21 Jun 2013 15:22:38 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <anup.patel@linaro.org>
Subject: Re: [PATCH] arm64: Add support to pass earlyprintk argument via
 device tree
Message-ID: <20130621142238.GB8384@darko.cambridge.arm.com>
References: <1370274671-23812-1-git-send-email-pranavkumar@linaro.org>
 <20130612132820.992E73E0A56@localhost>
 <CAAHg+HhhVOLn1DXizWAKOqZXczq9YR8dOXM+u=ywbEakw6A6ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAHg+HhhVOLn1DXizWAKOqZXczq9YR8dOXM+u=ywbEakw6A6ZQ@mail.gmail.com>
Thread-Topic: [PATCH] arm64: Add support to pass earlyprintk argument via
 device tree
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 07:25:20AM +0100, Pranavkumar Sawargaonkar wrote:
> On 12 June 2013 18:58, Grant Likely <grant.likely@secretlab.ca> wrote:
> > On Mon,  3 Jun 2013 21:21:11 +0530, Pranavkumar Sawargaonkar
> > <pranavkumar@linaro.org> wrote:
> >> One can just append earlyprintk=device-type,address (same as we pass
> >> through command line) in "/chosen" node to notify kernel which is the
> >> earlyprintk device and what is its address.
> >
> > I'm not a big fan of this. It seems to be short-circuiting around
> > existing properties. The kernel /should/ be able to use the
> > linux,stdout-path property to determine what the earlyprintk device
> > to use is.
> 
> For this there are two problems:
> 
> 1. Early printk code gets initialized before un-flattening of a device tree.
> Hence trying to find out node from stdout-path is tricky as we do not have
> of_find_node_by_path available.

Looking at the existing uses of linux,stdout-path, it seems that it is
pointed at an existing entry like &uart0, which cannot be parsed early
enough. The base address is the main problem as it needs the DT to be
unflattened (for example v2m_serial0 on arm64 would read as 0x90000
which is just an offset). If you pass the full path,
of_find_node_by_path() wouldn't work either this early.

Question for the DT guys - would it be feasible to pass a
@<phys address> via the linux,stdout-path? Any other way to get the phys
address of the device early during boot?

> 2. Current compatible strings in arm64 early printk code are not in
> synced (or different) from actual compatible strings used in drivers -
> e.g. for PL011 In earlyprintk code match name is just pl011 but in dts
> it is specified as "arm,pl011" Hence we will need multiple changes to
> implement it.

I think we can sort this out. The first point is more important.

-- 
Catalin
