Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965179Ab3CSWM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:12:57 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:37002 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964950Ab3CSWMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:12:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130316040200.15064.86851.stgit@localhost6.localdomain6>
Date: Tue, 19 Mar 2013 15:12:48 -0700
In-Reply-To: <20130316040200.15064.86851.stgit@localhost6.localdomain6>
	(HATAYAMA Daisuke's message of "Sat, 16 Mar 2013 13:02:00 +0900")
Message-ID: <871ubbm42n.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19kEvIgsU+qa4O0Q7c0ccyA8CeA/wUIcm4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 13/21] kexec: allocate vmcoreinfo note buffer on page-size boundary
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:

> To satisfy mmap()'s page-size boundary requirement, specify aligned
> attribute to vmcoreinfo_note objects to allocate it on page-size
> boundary.

Those requirements don't exist.  Making this patch wasteful and wrong.

Eric

> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
>
>  include/linux/kexec.h |    6 ++++--
>  kernel/kexec.c        |    2 +-
>  2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index d2e6927..5113570 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -185,8 +185,10 @@ extern struct kimage *kexec_crash_image;
>  #define VMCOREINFO_BYTES           (4096)
>  #define VMCOREINFO_NOTE_NAME       "VMCOREINFO"
>  #define VMCOREINFO_NOTE_NAME_BYTES ALIGN(sizeof(VMCOREINFO_NOTE_NAME), 4)
> -#define VMCOREINFO_NOTE_SIZE       (KEXEC_NOTE_HEAD_BYTES*2 + VMCOREINFO_BYTES \
> -				    + VMCOREINFO_NOTE_NAME_BYTES)
> +#define VMCOREINFO_NOTE_SIZE       ALIGN(KEXEC_NOTE_HEAD_BYTES*2	\
> +					 +VMCOREINFO_BYTES		\
> +					 +VMCOREINFO_NOTE_NAME_BYTES,	\
> +					 PAGE_SIZE)
>  
>  /* Location of a reserved region to hold the crash kernel.
>   */
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index d1f365e..195de6d 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -43,7 +43,7 @@ note_buf_t __percpu *crash_notes;
>  
>  /* vmcoreinfo stuff */
>  static unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
> -u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
> +u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4] __aligned(PAGE_SIZE);
>  size_t vmcoreinfo_size;
>  size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
>  
