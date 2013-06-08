Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab3FHVBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 17:01:10 -0400
Received: from threespeedlogic.com ([75.98.167.93]:58118 "EHLO
	threespeedlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3FHVBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 17:01:09 -0400
Message-ID: <51B39B11.8030900@threespeedlogic.com>
Date: Sat, 08 Jun 2013 13:58:57 -0700
From: Graeme Smecher <gsmecher@threespeedlogic.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: Don't mark arch_kgdb_ops as const.
References: <1370710328-15011-1-git-send-email-gsmecher@threespeedlogic.com>
In-Reply-To: <1370710328-15011-1-git-send-email-gsmecher@threespeedlogic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s63.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - threespeedlogic.com
X-Get-Message-Sender-Via: a2s63.a2hosting.com: authenticated_id: gsmecher+threespeedlogic.com/only user confirmed/virtual account not confirmed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 08/06/13 09:52 AM, Graeme Smecher wrote:
> Other architectures don't do it, and it conflicts with the extern'd definition
> in include/linux/kgdb.h.
>
> Signed-off-by: Graeme Smecher<gsmecher@threespeedlogic.com>
> CC: Michal Simek<monstr@monstr.eu>
> CC:linux-kernel@vger.kernel.org
> ---
>   arch/microblaze/kernel/kgdb.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/microblaze/kernel/kgdb.c b/arch/microblaze/kernel/kgdb.c
> index 8adc9244..09a5e82 100644
> --- a/arch/microblaze/kernel/kgdb.c
> +++ b/arch/microblaze/kernel/kgdb.c
> @@ -141,7 +141,7 @@ void kgdb_arch_exit(void)
>   /*
>    * Global data
>    */
> -const struct kgdb_arch arch_kgdb_ops = {
> +struct kgdb_arch arch_kgdb_ops = {
>   #ifdef __MICROBLAZEEL__
>   	.gdb_bpt_instr = {0x18, 0x00, 0x0c, 0xba}, /* brki r16, 0x18 */
>   #else

It's worth noting that this patch is flagged by checkpatch:

    WARNING: struct kgdb_arch should normally be const
    #25: FILE: arch/microblaze/kernel/kgdb.c:144:
    +struct kgdb_arch arch_kgdb_ops = {

    total: 0 errors, 1 warnings, 8 lines checked


However, without it, my kernel fails to compile:

       CC      arch/microblaze/kernel/kgdb.o
    arch/microblaze/kernel/kgdb.c:144:24: error: conflicting type
    qualifiers for 'arch_kgdb_ops'
    include/linux/kgdb.h:284:26: note: previous declaration of
    'arch_kgdb_ops' was here
    make[1]: *** [arch/microblaze/kernel/kgdb.o] Error 1
    make: *** [arch/microblaze/kernel] Error 2


The checkpatch test was a response to this (rejected) patch series:

http://lkml.indiana.edu/hypermail/linux/kernel/0912.1/02659.html

I'm the lucky victim, here, since I'm using gcc 4.6.4 (which notices the 
conflicting qualifiers), while other Microblaze users are still working 
with gcc 4.1.2 (which didn't care.) All other architectures (including 
mn10300, arc, and hexagon, which were accepted after the checkpatch 
commit) ignore the checkpatch rule and declare arch_kgdb_ops non-const.

In any case, I wanted to point out (a) that the patch fails checkpatch, 
(b) that I'm submitting it anyway, and (c) that I'm utterly ambivalent 
about how the struct is declared, provided I can compile working kernels 
on Microblaze.

cheers,
Graeme

