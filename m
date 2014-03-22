Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaCVWCI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 18:02:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:60194 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaCVWCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 18:02:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 0/8] Generic serial earlycon
Date: Sat, 22 Mar 2014 23:01:30 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, "x86@kernel.org" <x86@kernel.org>
References: <1395436128-11244-1-git-send-email-robherring2@gmail.com> <201403221054.39799.arnd@arndb.de> <CAL_JsqKjGjyYypwneCmNc1qeKe0ZOG9gz3QSJ37-HwHXKu3iRA@mail.gmail.com>
In-Reply-To: <CAL_JsqKjGjyYypwneCmNc1qeKe0ZOG9gz3QSJ37-HwHXKu3iRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403222301.30222.arnd@arndb.de>
X-Provags-ID: V02:K0:M+YqSiKyVzW6Aabjj7WJ4Jqt/UaQKiuF7rVX+4INlsX
 008+DImozsZTz32zRaxOCSGy05xJnACuFex1fA4pOikwu+NaRs
 TmIsGuAfmZjdsJX2Npnii5/XSPu7DCjZRiLiHoIKHvpsJXnW7U
 2rk1CDLYU7gzJsh509DU6wfcLu9zJrMt4IrdC1azORKM/+3RKY
 pd2jwM994d5P/m21AFTLhUmjpMmAGgO3zHkjTToKQAxiPZ0Pxf
 /3iQyed5sYg7G2cKLyJLHbJeQJBVw4Jn2fdMyu6uhrjaKD/lN6
 /9jv8UKtA+j5jmlv816FgR+la+Q5fpK05P9+yNVBar2x2mJOg4
 KDtEofYI2DUsebDb6BK7NVG4K3Uapbk3KXvE8wV/F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 March 2014, Rob Herring wrote:
> I think this series stands on its own. It is largely refactoring
> existing code and supporting existing command line options (arm64 just
> changes from earlyprintk= to earlycon=). There will be cases where
> changing the kernel command line is the only way to setup the
> earlycon. Also, I think we would still want the kernel command line to
> control whether or not we enable the earlycon (i.e. earlycon=dt).
> There's not a standard way for how bootloaders would decide to set
> "linux,stdout-path" or not.
> 
> The DT support won't be all that quick to implement. The challenge
> with the DT parsing is we have to do it on the flattened DT. I have
> something functioning, but it doesn't do any address translation which
> is the hard part.

Ah, I hadn't realized that we call parse_early_param() twice, both
in start_kernel() and before that in setup_arch(). You are right
that the first one of these can only look at the flat device tree
at the moment. I wonder if that's out of necessity or just coincidence
though.

There is relatively little going on between the first parse_early_param()
and the call to unflatten_device_tree(), so it may be possible to move
the former down, or the latter up.

        parse_early_param();

        sort(&meminfo.bank, meminfo.nr_banks, sizeof(meminfo.bank[0]), meminfo_cmp, NULL);

        early_paging_init(mdesc, lookup_processor_type(read_cpuid_id()));
        setup_dma_zone(mdesc);  
        sanity_check_meminfo();
        arm_memblock_init(&meminfo, mdesc);
                                
        paging_init(mdesc);
        request_standard_resources(mdesc);
                
        if (mdesc->restart)
                arm_pm_restart = mdesc->restart;
        
        unflatten_device_tree();

On powerpc, unflatten_device_tree is called way before paging_init, so I assume
it has to be possible, but it might end up being harder to do than what you
have in mind with parsing the flat device tree.

	Arnd
