Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaKKD7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 22:59:10 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:46045 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaKKD7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 22:59:07 -0500
Date: Mon, 10 Nov 2014 20:59:02 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-pci@vger.kernel.org, Myron Stowe <mstowe@redhat.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] pci, add FW_BUG warning to pci= kernel option
Message-ID: <20141111035902.GC28161@google.com>
References: <1414865479-25792-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414865479-25792-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc lkml, linux-arch, Linus]

On Sat, Nov 01, 2014 at 02:11:19PM -0400, Prarit Bhargava wrote:
> The kernel should boot PCI without the use of kernel parameters.  Display
> a FW_BUG warning when pci= is used.
> 
> Cc: Myron Stowe <mstowe@redhat.com>
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> ---
>  drivers/pci/pci.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 625a4ac..5172060b 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -4515,6 +4515,8 @@ static int __init pci_setup(char *str)
>  		}
>  		str = k;
>  	}
> +	add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
> +	pr_crit(FW_BUG "The PCI configuration has been overridden thorugh the use of pci=.  Please report the issue you are attempting to resolve to your hardware vendor.\n");

My goal is to be able to boot without any "pci=" parameters, so from that
perspective, I like this.

When people have a problem booting Linux, they often try a variety of
things like "pci=assign-busses", "pci=nocrs", "pci=nomsi", "pci=nommconf",
"pci=noacpi", etc.  If they find something that works, there's a tendency
to treat that as a "solution."  I'd rather that they report it, so we can
try to fix the bug or add a quirk so the *next* person won't have to figure
out the right parameters to use.

My worry is that there are a few things where Linux isn't smart enough to
do the right thing automatically, and I don't think we'll have a good
solution in the near future.  For example:

    pci=norom
    pci=pcie_bus_perf,pcie_bus_safe,etc.
    pci=cbiosize=...
    pci=cbmemsize=...
    pci=resource_alignment=...
    pci=hpiosize=...
    pci=hpmemsize=...
    pci=realloc

I don't like the fact that these options exist, but I suspect there are
users that do depend on them and might find this warning too aggressive.

So I'm interested in opinions on whether this is a good idea at all and
whether we should exclude some options from the warning/tainting.

Bjorn

>  	return 0;
>  }
>  early_param("pci", pci_setup);
> -- 
> 1.7.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
