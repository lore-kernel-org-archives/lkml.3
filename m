Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaFDLJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:09:19 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:50165 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaFDLJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:09:17 -0400
Date: Wed, 4 Jun 2014 13:09:12 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Julia Lawall <Julia.Lawall@lip6.fr>
cc: kernel-janitors@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/10] s390/pci: use safer test on the result of
 find_first_zero_bit
In-Reply-To: <1401872880-23685-9-git-send-email-Julia.Lawall@lip6.fr>
Message-ID: <alpine.LFD.2.11.1406041308450.1560@denkbrett>
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr> <1401872880-23685-9-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060411-3548-0000-0000-0000095C9D8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Find_first_zero_bit considers BITS_PER_LONG bits at a time, and thus may
> return a larger number than the maximum position argument if that position
> is not a multiple of BITS_PER_LONG.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e1,e2,e3;
> statement S1,S2;
> @@
> 
> e1 = find_first_zero_bit(e2,e3)
> ...
> if (e1 
> - ==
> + >=
>   e3)
> S1 else S2
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  arch/s390/pci/pci.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -u -p a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -566,7 +566,7 @@ static int zpci_alloc_iomap(struct zpci_
> 
>  	spin_lock(&zpci_iomap_lock);
>  	entry = find_first_zero_bit(zpci_iomap, ZPCI_IOMAP_MAX_ENTRIES);
> -	if (entry == ZPCI_IOMAP_MAX_ENTRIES) {
> +	if (entry >= ZPCI_IOMAP_MAX_ENTRIES) {
>  		spin_unlock(&zpci_iomap_lock);
>  		return -ENOSPC;
>  	}
> @@ -746,7 +746,7 @@ static int zpci_alloc_domain(struct zpci
>  {
>  	spin_lock(&zpci_domain_lock);
>  	zdev->domain = find_first_zero_bit(zpci_domain, ZPCI_NR_DEVICES);
> -	if (zdev->domain == ZPCI_NR_DEVICES) {
> +	if (zdev->domain >= ZPCI_NR_DEVICES) {
>  		spin_unlock(&zpci_domain_lock);
>  		return -ENOSPC;
>  	}
> 
> 

Thanks, applied.
Sebastian

