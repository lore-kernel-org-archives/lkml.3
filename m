Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaKUVTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:19:10 -0500
Received: from smtp105.biz.mail.bf1.yahoo.com ([98.139.221.43]:48519 "EHLO
	smtp105.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbaKUVTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:19:08 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5AgdPDYVM1kgU_njdYBKrdQYyMeibOCteoWWd5nsRjK726p
 aZnBaJxrp2STB8LuC_ZMFqOMiwn2_oajdqbgOFwYSce.hJGYiFJrcDrjw2qS
 ELX4CtdRbw6xeSgY4JEu4IWw5FXHAJFiIgqGAnfRJyyoB6ui0XJKy2OLhf7u
 .co.ZObgPA_o9bXpRESBexqlt2N8aUH_APEMc2K3M1zbmzY.BbqAbp7QGCs8
 HovigHagFdtn8etuXGPYjw3EzjkQKjeYRRxIZ.eHx_2BfO.QCbnC3KuZJ3VE
 Rd8mZocoukLZ78VscWfDT.80O82Ak29wV4rUWsVqjCwEe2TEf8jQKI34crfR
 tzq48Ji2VKXH1M_9wAU7RYAXnQPtlyAkeGDB1ONK2.mlUyybs79Y7C.5lJRa
 fDrxknogxnR_t_gXS5vrPVr555cCvmZd4b1B_6ISEufi6fwovOUEpzShPe_F
 POvwN5GQY9H4U9o7wSolhUplP8l5R1W3w1L9CIMAiXwH0ZHTLYYk6ez.M9cj
 WKn5Ab9yGVF0T.lS3WFqMLt5gNysAvUpPP3AT8ZMxgJ6btxXuNlStwKXoXfp
 ZvXzg7mZ1yVFN9jDd5NYceBHvuSeIYQj6sfOlF176b0O2dzda1q8XLu4H0gF
 OB2uOkeDcow--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <546FAC52.7060300@schaufler-ca.com>
Date: Fri, 21 Nov 2014 13:19:14 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: Re: [PATCH] security: smack: fix out-of-bounds access in smk_parse_smack()
References: <1415458085-12485-1-git-send-email-ryabinin.a.a@gmail.com>
In-Reply-To: <1415458085-12485-1-git-send-email-ryabinin.a.a@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/8/2014 6:48 AM, Andrey Ryabinin wrote:
> From: Andrey Ryabinin <a.ryabinin@samsung.com>
>
> Setting smack label on file (e.g. 'attr -S -s SMACK64 -V "test" test')
> triggered following spew on the kernel with KASan applied:
>     ==================================================================
>     BUG: AddressSanitizer: out of bounds access in strncpy+0x28/0x60 at addr ffff8800059ad064
>     =============================================================================
>     BUG kmalloc-8 (Not tainted): kasan error
>     -----------------------------------------------------------------------------
>
>     Disabling lock debugging due to kernel taint
>     INFO: Slab 0xffffea0000166b40 objects=128 used=7 fp=0xffff8800059ad080 flags=0x4000000000000080
>     INFO: Object 0xffff8800059ad060 @offset=96 fp=0xffff8800059ad080
>
>     Bytes b4 ffff8800059ad050: a0 df 9a 05 00 88 ff ff 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
>     Object ffff8800059ad060: 74 65 73 74 6b 6b 6b a5                          testkkk.
>     Redzone ffff8800059ad068: cc cc cc cc cc cc cc cc                          ........
>     Padding ffff8800059ad078: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
>     CPU: 0 PID: 528 Comm: attr Tainted: G    B          3.18.0-rc1-mm1+ #5
>     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
>      0000000000000000 ffff8800059ad064 ffffffff81534cf2 ffff880005a5bc40
>      ffffffff8112fe1a 0000000100800006 0000000f059ad060 ffff880006000f90
>      0000000000000296 ffffea0000166b40 ffffffff8107ca97 ffff880005891060
>     Call Trace:
>     ? dump_stack (lib/dump_stack.c:52)
>     ? kasan_report_error (mm/kasan/report.c:102 mm/kasan/report.c:178)
>     ? preempt_count_sub (kernel/sched/core.c:2651)
>     ? __asan_load1 (mm/kasan/kasan.h:50 mm/kasan/kasan.c:248 mm/kasan/kasan.c:358)
>     ? strncpy (lib/string.c:121)
>     ? strncpy (lib/string.c:121)
>     ? smk_parse_smack (security/smack/smack_access.c:457)
>     ? setxattr (fs/xattr.c:343)
>     ? smk_import_entry (security/smack/smack_access.c:514)
>     ? smack_inode_setxattr (security/smack/smack_lsm.c:1093 (discriminator 1))
>     ? security_inode_setxattr (security/security.c:602)
>     ? vfs_setxattr (fs/xattr.c:134)
>     ? setxattr (fs/xattr.c:343)
>     ? setxattr (fs/xattr.c:360)
>     ? get_parent_ip (kernel/sched/core.c:2606)
>     ? preempt_count_sub (kernel/sched/core.c:2651)
>     ? __percpu_counter_add (arch/x86/include/asm/preempt.h:98 lib/percpu_counter.c:90)
>     ? get_parent_ip (kernel/sched/core.c:2606)
>     ? preempt_count_sub (kernel/sched/core.c:2651)
>     ? __mnt_want_write (arch/x86/include/asm/preempt.h:98 fs/namespace.c:359)
>     ? path_setxattr (fs/xattr.c:380)
>     ? SyS_lsetxattr (fs/xattr.c:397)
>     ? system_call_fastpath (arch/x86/kernel/entry_64.S:423)
>     Read of size 1 by task attr:
>     Memory state around the buggy address:
>      ffff8800059ace80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>      ffff8800059acf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>      ffff8800059acf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>     >ffff8800059ad000: 00 fc fc fc 00 fc fc fc 05 fc fc fc 04 fc fc fc
>                                                            ^
>      ffff8800059ad080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>      ffff8800059ad100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>      ffff8800059ad180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>     ==================================================================
>
> strncpy() copies one byte more than the source string has.
> Fix this by passing the correct length to strncpy().
>
> Now we can remove initialization of the last byte in 'smack' string
> because kzalloc() already did this for us.
>
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>

Applied to git://git.gitorious.org/smack-next/kernel.git#smack-for-3.19

> ---
>  security/smack/smack_access.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index 5b970ff..ad75ddf 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -452,10 +452,9 @@ char *smk_parse_smack(const char *string, int len)
>  		return NULL;
>  
>  	smack = kzalloc(i + 1, GFP_KERNEL);
> -	if (smack != NULL) {
> -		strncpy(smack, string, i + 1);
> -		smack[i] = '\0';
> -	}
> +	if (smack != NULL)
> +		strncpy(smack, string, i);
> +
>  	return smack;
>  }
>  

