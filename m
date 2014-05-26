Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaEZORV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:17:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:4777 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbaEZORU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:17:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,913,1392192000"; 
   d="scan'208";a="517865394"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Jeff Smith <jsmith.lkml@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <CAAih0Nige+Cjoh6c=718P2R4BV5=RczuGh17voVgZEc_hyz16Q@mail.gmail.com>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
 <20140519130114.GA3140@dhcp22.suse.cz>
 <20140519143540.BE9F6E009B@blue.fi.intel.com>
 <20140519143837.GA5228@infradead.org>
 <CAAih0NjpHKc11JfG3MOnvisXesg-LoaS0Cx1rOA5ggDEHNfY6g@mail.gmail.com>
 <20140526094240.B5508E009B@blue.fi.intel.com>
 <CAAih0Nght-5k6mp-_jc+GipxPfxPYdCEabH_8M2QMkM_B5FPWw@mail.gmail.com>
 <53834310.8060808@redhat.com>
 <CAAih0NhTXOb+Hj+u+0QLrADxyOYc-EwHDCx5+1Fq7wiJsaY=_Q@mail.gmail.com>
 <20140526134718.0AAC7E009B@blue.fi.intel.com>
 <CAAih0Nige+Cjoh6c=718P2R4BV5=RczuGh17voVgZEc_hyz16Q@mail.gmail.com>
Subject: Re: remap_file_pages() use
Content-Transfer-Encoding: 7bit
Message-Id: <20140526141655.295DDE009B@blue.fi.intel.com>
Date: Mon, 26 May 2014 17:16:55 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Smith wrote:
> I've got no real issues at this point, but could you perhaps elaborate
> a bit on the rough order of magnitude of "long" time

We have never-break-ABI policy in kernel. In practice it means we don't
remove an interface if somebody could notice that it disappears.

Most likely it will go though intermediate step with separate kernel
config option, like uselib(2) recently.

Don't worry. Just convert your code to avoid remap_file_pages() where it's
possible.

> and what cases would be slower?

With emulation each remap_file_pages() will usually create one or two
additional kernel structure which represents part of virtual address space
of the process. Kernel often needs to lookup that structure by virtual
address and this operation can be slower with high number of structures.

I've tried to test how bad it would be in near-worst case: 4G mapped in
reverse page order. It creates 1 million structures. On my machine, fault
in of all this memory is ~1.9 times slower with emulation comparing to
original remap_file_pages(2). In practice, nobody will notice, I believe.

-- 
 Kirill A. Shutemov
