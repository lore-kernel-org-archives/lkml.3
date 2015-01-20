Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbbATM4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:56:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbbATM4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:56:00 -0500
Date: Tue, 20 Jan 2015 13:55:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Cox <alan@linux.intel.com>
cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] doubletalk: probe failure causes OOPS
In-Reply-To: <20141215113246.25566.52447.stgit@localhost.localdomain>
Message-ID: <alpine.LNX.2.00.1501201355410.10817@pobox.suse.cz>
References: <20141215113246.25566.52447.stgit@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2014, Alan Cox wrote:

> The code bothers to probe for the device, but on failing to find it proceeds
> to try and release a NULL resource, thereby ruining it's prior good
> behaviour
> 
> Resolves-Bug: https://bugzilla.kernel.org/show_bug.cgi?id=88581
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Doesn't seem to be in linux-next as of today, so I am picking it up.

> ---
>  drivers/staging/speakup/speakup_dtlk.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/speakup/speakup_dtlk.c b/drivers/staging/speakup/speakup_dtlk.c
> index d7d5152..ffd85e1 100644
> --- a/drivers/staging/speakup/speakup_dtlk.c
> +++ b/drivers/staging/speakup/speakup_dtlk.c
> @@ -325,7 +325,7 @@ static struct synth_settings *synth_interrogate(struct spk_synth *synth)
>  
>  static int synth_probe(struct spk_synth *synth)
>  {
> -		unsigned int port_val = 0;
> +	unsigned int port_val = 0;
>  	int i = 0;
>  	struct synth_settings *sp;
>  
> @@ -361,7 +361,8 @@ static int synth_probe(struct spk_synth *synth)
>  	port_val &= 0xfbff;
>  	if (port_val != 0x107f) {
>  		pr_info("DoubleTalk PC: not found\n");
> -		synth_release_region(synth_lpc, SYNTH_IO_EXTENT);
> +		if (synth_lpc)
> +			synth_release_region(synth_lpc, SYNTH_IO_EXTENT);
>  		return -ENODEV;
>  	}
>  	while (inw_p(synth_lpc) != 0x147f)
> @@ -369,7 +370,7 @@ static int synth_probe(struct spk_synth *synth)
>  	sp = synth_interrogate(synth);
>  	pr_info("%s: %03x-%03x, ROM ver %s, s/n %u, driver: %s\n",
>  		synth->long_name, synth_lpc, synth_lpc+SYNTH_IO_EXTENT - 1,
> -	 sp->rom_version, sp->serial_number, synth->version);
> +		sp->rom_version, sp->serial_number, synth->version);
>  	synth->alive = 1;
>  	return 0;
>  }
> 

-- 
Jiri Kosina
SUSE Labs
