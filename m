Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaLaTma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 14:42:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaLaTm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 14:42:29 -0500
Date: Wed, 31 Dec 2014 20:42:22 +0100
From: Mark Wielaard <mjw@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf-probe crash in dwarf_getcfi_elf
Message-ID: <20141231194222.GB2897@blokker.redhat.com>
References: <54A22C76.9000403@gmail.com>
 <20141230084708.GG6081@sejong>
 <20141230090533.GH6081@sejong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141230090533.GH6081@sejong>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 06:05:33PM +0900, Namhyung Kim wrote:
> And I found a related commit (5704c8c4fa71 "getcfi_scn_eh_frame: Don't
> crash and burn when .eh_frame bits aren't there.") in elfutils that
> can lead to a unexpected crash like this.  To safely use the function,
> it needs to check the .eh_frame section is a PROGBITS type.

Sorry about that bug. It was fixed in elfutils 0.156, released July 2013.
Latest elfutils release is 0.161.

Checking .eh_frame is SHT_PROGBITS (and not SHT_NOBITS) looks like the
correct workaround if you have to deal with older elfutils releases.

Note that dwarf_getcfi_elf gets the CFI information from the .eh_frame
section associated with the ELF file underlying the Dwarf dbg and needs
to be released with a call to dwarf_cfi_end (). dwarf_getcfi () gets the
CFI information from the .debug_frame section data of the Dwarf dbg
and gets automatically releassed when dwarf_end () is called (you should
not call dwarf_cfi_end () on the result).

If the Dwarf dbg handle is associated with a separate debuginfo file,
then the .eh_frame section data will not be available (has SHT_NOBITS)
and you can get the .eh_frame section (and call dwarf_getcfi_elf ()) on
the original ELF file from which the Dwarf debuginfo file was split off.

In your patch you call dwarf_getcfi () as backup to get some CFI
information when you cannot call dwarf_getcfi_elf (). In general it
might make sense to also do this when dwarf_getcfi_elf fails. Or try
to get the CFI through both .eh_frame (from the executable ELF file)
with dwarf_getcfi_elf () and .debug_frame (from the Dwarf dbg file)
with dwarf_getcfi () and try to match an address in both tables
if one or the other fails.

Cheers,

Mark
