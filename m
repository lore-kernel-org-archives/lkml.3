Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbbAJVgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:36:25 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:62026 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbbAJVgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:36:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.19-rc3
Date: Sat, 10 Jan 2015 22:36:13 +0100
Message-ID: <10028397.kdbz8TfPck@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CA+55aFxphoLdFkwkVFQ87Q8EbYNqFAE-n0yTvCSOJzSO2MtDgw@mail.gmail.com>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com> <4665410.x9Uu42bKmJ@wuerfel> <CA+55aFxphoLdFkwkVFQ87Q8EbYNqFAE-n0yTvCSOJzSO2MtDgw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:SvWWiYOnV1n/x3l9yxZi2AFMchP7DMiyyxBsFpqxjw7r/K9a49h
 ZyMys/TeqcHZcFOG7k9bHWdknr2AvMLy/dGnNIr9gQRtABF+9YOSJont/cEIekUv9ennSAB
 m0MQAWUdV5amzrpf24my1tFr7MRpoc9wyB6gTo42NkVSCKb1lWgEQxbPWddZZBEe6HmMzEM
 7OsjLKY8tu2MVX+s0s0+Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 January 2015 13:00:27 Linus Torvalds wrote:
> 
> > IIRC, AIX works great with 64k pages, but only because of two
> > reasons that don't apply on Linux:
> 
> .. there's a few other ones:
> 
>  (c) nobody really runs AIX on dekstops. It's very much a DB load
> environment, with historically some HPC.
> 
>  (d) the powerpc TLB fill/buildup/teardown costs are horrible, so on
> AIX the cost of lots of small pages is much higher too.

I think (d) applies to ARM as well, since it has no hardware
dirty/referenced bit tracking and requires the OS to mark the
pages as invalid/readonly until the first access. ARMv8.1
has a fix for that, but it's optional and we haven't seen any
implementations yet.

> so I feel pretty confident in saying it won't happen. It's just too
> much of a bother, for little to no actual upside. It's likely a much
> better approach to try to instead use THP for anonymous mappings.

arm64 already supports 2MB transparent hugepages. I guess it
wouldn't be too hard to change it so that an existing hugepage
on an anonymous mapping that gets split up into 4KB pages gets
split along 64KB boundaries with the contiguous mapping bit set.

Having full support for multiple hugepage sizes (64KB, 2MB and 32MB
in case of ARM64 with 4KB PAGE_SIZE) would be even better and
probably negate any benefits of 64KB PAGE_SIZE, but requires more
changes to common mm code.

	Arnd
