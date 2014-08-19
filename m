Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaHSNZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 09:25:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaHSNZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 09:25:58 -0400
From: jgross@suse.com
To: stefan.bader@canonical.com, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, ville.syrjala@linux.intel.com, hpa@zytor.com,
        x86@kernel.org
Subject: [PATCH RFC 0/3] x86: Full support of PAT
Date: Tue, 19 Aug 2014 15:25:42 +0200
Message-Id: <1408454745-32358-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 architecture offers via the PAT (Page Attribute Table) a way to
specify different caching modes in page table entries. The PAT MSR contains
8 entries each specifying one of 6 possible cache modes. A pte references one
of those entries via 3 bits: _PAGE_PAT, _PAGE_PWT and _PAGE_PCD.

The Linux kernel currently supports only 4 different cache modes. The PAT MSR
is set up in a way that the setting of _PAGE_PAT in a pte doesn't matter: the
top 4 entries in the PAT MSR are the same as the 4 lower entries.

This results in the kernel not supporting e.g. write-through mode. Especially
this cache mode would speed up drivers of video cards which now have to use
uncached accesses.

OTOH some old processors (Pentium) don't support PAT and the Xen hypervisor
has been using a different PAT MSR configuration for some time now and can't
change that as this setting is part of the ABI.

This patch set abstracts the cache mode from the pte and introduces tables to
translate between cache mode and pte bits (the default cache mode "write back"
is hard-wired to PAT entry 0). The tables are statically initialized with
values being compatible to old processors and current usage. As soon as the
PAT MSR is changed (or - in case of Xen - is read at boot time) the tables are
changed accordingly. Requests of mappings with special cache modes are always
possible now, in case they are not supported there will be a fallback to a
compatible but slower mode.

[PATCH RFC 1/3] x86: Make page cache mode a real type
[PATCH RFC 2/3] x86: Enable PAT to use cache mode translation tables
[PATCH RFC 3/3] Support Xen pv-domains using PAT
