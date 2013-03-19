Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964895Ab3CSWMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:12:18 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36225 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab3CSWMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:12:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130316040154.15064.35482.stgit@localhost6.localdomain6>
Date: Tue, 19 Mar 2013 15:12:10 -0700
In-Reply-To: <20130316040154.15064.35482.stgit@localhost6.localdomain6>
	(HATAYAMA Daisuke's message of "Sat, 16 Mar 2013 13:01:54 +0900")
Message-ID: <877gl3m43p.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+Y8FZyZX1pgTmNsrZ9lTkHTuq1hpQdSEA=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 12/21] vmcore: allocate per-cpu crash_notes objects on page-size boundary
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:

> To satisfy mmap()'s page-size boundary requirement, allocate per-cpu
> crash_notes objects on page-size boundary.
>
> /proc/vmcore on the 2nd kernel checks if each note objects is
> allocated on page-size boundary. If there's some object not satisfying
> the page-size boundary requirement, /proc/vmcore doesn't provide
> mmap() interface.

On second look this requirement does not exist.  These all get copyied
into the unifed PT_NOTE segment so this patch is pointless and wrong.

I see no evidence of any need to change anything in the first kernel,
and this noticably increases the amount of memory used in the first
kernel and in the second kernel for no gain.

Eric

>
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
>
>  kernel/kexec.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index bddd3d7..d1f365e 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1234,7 +1234,8 @@ void crash_save_cpu(struct pt_regs *regs, int cpu)
>  static int __init crash_notes_memory_init(void)
>  {
>  	/* Allocate memory for saving cpu registers. */
> -	crash_notes = alloc_percpu(note_buf_t);
> +	crash_notes = __alloc_percpu(roundup(sizeof(note_buf_t), PAGE_SIZE),
> +				     PAGE_SIZE);
>  	if (!crash_notes) {
>  		printk("Kexec: Memory allocation for saving cpu register"
>  		" states failed\n");
