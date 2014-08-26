Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaHZSss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:48:48 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:36482 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaHZSsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:48:47 -0400
Message-ID: <53FCD68A.40509@amacapital.net>
Date: Tue, 26 Aug 2014 11:48:42 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, stefan.bader@canonical.com,
        toshi.kani@hp.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH 0/3] x86: Full support of PAT
References: <1409033783-12136-1-git-send-email-jgross@suse.com>
In-Reply-To: <1409033783-12136-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2014 11:16 PM, Juergen Gross wrote:
> The x86 architecture offers via the PAT (Page Attribute Table) a way to
> specify different caching modes in page table entries. The PAT MSR contains
> 8 entries each specifying one of 6 possible cache modes. A pte references one
> of those entries via 3 bits: _PAGE_PAT, _PAGE_PWT and _PAGE_PCD.
> 
> The Linux kernel currently supports only 4 different cache modes. The PAT MSR
> is set up in a way that the setting of _PAGE_PAT in a pte doesn't matter: the
> top 4 entries in the PAT MSR are the same as the 4 lower entries.
> 
> This results in the kernel not supporting e.g. write-through mode. Especially
> this cache mode would speed up drivers of video cards which now have to use
> uncached accesses.
> 
> OTOH some old processors (Pentium) don't support PAT correctly and the Xen
> hypervisor has been using a different PAT MSR configuration for some time now
> and can't change that as this setting is part of the ABI.
> 
> This patch set abstracts the cache mode from the pte and introduces tables to
> translate between cache mode and pte bits (the default cache mode "write back"
> is hard-wired to PAT entry 0). The tables are statically initialized with
> values being compatible to old processors and current usage. As soon as the
> PAT MSR is changed (or - in case of Xen - is read at boot time) the tables are
> changed accordingly. Requests of mappings with special cache modes are always
> possible now, in case they are not supported there will be a fallback to a
> compatible but slower mode.

I feel like I'm missing something here.  Where's the support for the
high PAT bit on huge pages?  Once you start using the top four entries,
you'll need that.

Also, this probably needs errata handling.  IIRC there are a handful of
CPUs that support PAT but don't work correctly if the high bit is set.

--Andy
