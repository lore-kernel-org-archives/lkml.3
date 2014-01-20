Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaATK2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 05:28:10 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:36420 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaATK2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 05:28:06 -0500
Message-ID: <52DCF41E.1060604@gmail.com>
Date: Mon, 20 Jan 2014 11:02:06 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>
CC: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org, criu@openvz.org
Subject: Re: [PATCH 2/3] ptrace.2: add description for PTRACE_PEEKSIGINFO
References: <1373962773-2041-1-git-send-email-avagin@openvz.org> <1373962773-2041-3-git-send-email-avagin@openvz.org>
In-Reply-To: <1373962773-2041-3-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey,


On 07/16/2013 10:19 AM, Andrey Vagin wrote:
> Retrieve signals without removing them from a queue.
> 
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  man2/ptrace.2 | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/man2/ptrace.2 b/man2/ptrace.2
> index 5fcac2b..e74535e 100644
> --- a/man2/ptrace.2
> +++ b/man2/ptrace.2
> @@ -317,6 +317,45 @@ itself.
>  .RI ( addr
>  is ignored.)
>  .TP
> +.BR PTRACE_PEEKSIGINFO " (since Linux 3.10)"
> +.\" commit 84c751bd4aebbaae995fe32279d3dba48327bad4
> +Retrieve
> +.I siginfo_t
> +structures without removing signals from a queue.
> +.I addr
> +points to a
> +.I ptrace_peeksiginfo_args
> +structure.
> +.I siginfo_t
> +structures are copied into the buffer starting at
> +.I data.
> +The return value contains a number of copied signals (zero indicates
> +that a signal with this sequence number doesn't exist).
> +A result
> +.I siginfo
> +contains a kernel part of
> +.IR si_code
> +(
> +.BR __SI_CHLD,
> +.BR __SI_FAULT,
> +etc), which is not shown in other places.
> +.PP
> +.in +10n
> +.nf
> +struct ptrace_peeksiginfo_args {
> +	u64 off;        /* from which siginfo to start */
> +	u32 flags;
> +	s32 nr;         /* how may siginfos to take */
> +};
> +.fi
> +
> +Currently here is only one flag
> +.BR PTRACE_PEEKSIGINFO_SHARED
> +for dumping signals from process-wide queue.
> +If this flag is not set, signals are read from a per-thread queue.
> +.in
> +.PP
> +.TP
>  .BR PTRACE_SETOPTIONS " (since Linux 2.4.6; see BUGS for caveats)"
>  Set ptrace options from
>  .IR data .

Long after the fact, I've applied this patch. I reworked the text 
somewhat as well. Could you please check that the following is correct:

       PTRACE_PEEKSIGINFO (since Linux 3.10)
              Retrieve  siginfo_t  structures without removing signals
              from a queue.  addr points to a  ptrace_peeksiginfo_args
              structure that specifies the ordinal position from which
              copying of signals should start, and the number of  sig‐
              nals  to copy.  siginfo_t structures are copied into the
              buffer pointed to by data.  The  return  value  contains
              the  number of copied signals (zero indicates that there
              is no signal  corresponding  to  the  specified  ordinal
              position).   Within the returned siginfo structures, the
              si_code   field   includes    information    (__SI_CHLD,
              __SI_FAULT,  etc.),  that  are  not otherwise exposed to
              user space.

                 struct ptrace_peeksiginfo_args {
                     u64 off;    /* Ordinal position in queue at which
                                    to start copying signals */
                     u32 flags;  /* PTRACE_PEEKSIGINFO_SHARED or 0 */
                     s32 nr;     /* Number of signals to copy */
                 };

                 Currently, there is only  one  flag,  PTRACE_PEEKSIG‐
                 INFO_SHARED,  for  dumping  signals from the process-
                 wide signal queue.  If this flag is not set,  signals
                 are  read  from the per-thread queue of the specified
                 thread.

Thanks for the patch!

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
