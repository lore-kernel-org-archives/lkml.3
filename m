Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaEUEeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 00:34:08 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44348 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaEUEeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 00:34:06 -0400
Date: Tue, 20 May 2014 21:32:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Kenny Simpson <theonetruekenny@gmail.com>
cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Armin Rigo <arigo@tunes.org>
Subject: Re: remap_file_pages() use
In-Reply-To: <CALN0BAvfgby97e69mMd+94pcn6AOPL=VPNesfu_W4_9rhkHZxw@mail.gmail.com>
Message-ID: <alpine.LSU.2.11.1405202112520.5142@eggly.anvils>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com> <20140519130114.GA3140@dhcp22.suse.cz> <20140519143540.BE9F6E009B@blue.fi.intel.com> <CALN0BAu0E9r0hdy_Vc6GoKiXXk_w0vetRdumW-3eFFzOPqsFSQ@mail.gmail.com> <20140519212416.GA14152@node.dhcp.inet.fi>
 <CALN0BAuzw74rLwrF+FvDWHHc+rtoF8+DAZwEOXzoWsVeS=GbCg@mail.gmail.com> <CALN0BAvfgby97e69mMd+94pcn6AOPL=VPNesfu_W4_9rhkHZxw@mail.gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014, Kenny Simpson wrote:

> I might need a gentle nudge with a clue stick...
> checking against latest git tree it looks as though most common
> filesystem types do support remap_file_pages.
> 
> I just wrote a simple test case and it worked on my 3.13-based ubuntu
> 14.04 system on an ext4 filesystem.

It is all very confusing, yes.

When Kirill said disk-backed files don't support remap_file_pages since
commit 3ee6dafc677a, he was meaning that that they do not support it
with a special nonlinear vma; but the remap_file_pages syscall emulates
the layout for them with separate linear vmas instead.

Confusingly, these filesystems opt in to this emulation by pointing
their remap_pages method to generic_file_remap_pages - code which is
then never used for them!  tmpfs is the only filesystem (having no
page_mkwrite) which actually passes through that code.

You can understand why there's some enthusiasm for cleaning this up :)

Hugh
