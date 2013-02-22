Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3BVBSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 20:18:08 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:10101 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3BVBSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 20:18:05 -0500
Subject: Re: prctl(PR_SET_MM)
To: akpm@linux-foundation.org (Andrew Morton)
Date: Fri, 22 Feb 2013 12:18:01 +1100 (EST)
Cc: gorcunov@openvz.org (Cyrill Gorcunov),
        rostedt@goodmis.org (Steven Rostedt), u3557@dialix.com.au,
        oleg@redhat.com (Oleg Nesterov), palves@redhat.com (Pedro Alves),
        dvlasenk@redhat.com (Denys Vlasenko),
        jan.kratochvil@redhat.com (Jan Kratochvil),
        xemul@parallels.com (Pavel Emelyanov),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra), linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <20130221141841.c760b02f.akpm@linux-foundation.org>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20130222011801.A28D059205C@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew,

The code in "kernel/sys.c" that is currently within
CONFIG_CHECKPOINT_RESTORE is in fact, as I explain below,
one possible solution to a general issue, required by a wide
class of applications.  It just so happened that the CRIU group
were the first to place this, or an equivalent code, in the kernel,
that allows a privileged process to set its 11 per-process memory-region
fields:
     start_code, end_code, start_data, end_data, start_brk, brk,
     start_stack, arg_start, arg_end, env_start, env_end.


Contrary to the rest of the CHECKPOINT_RESTORE code, which is specific
to the CRIU package, the code in "kernel/sys.c" (or its equivalent) is
needed by ANY application or package that needs to reconstruct Linux
processes, that means, starting them from the middle rather than from
an executable file.

That includes user-level checkpointing (any, not just CRIU's),
process-migration (to other computers, as my own package does)
and process duplication (for high-availability/reliability) -
in fact even for starting a process from an executable format
that is not supported by Linux, thus requiring a "manual execve"
by a user-level utility.

My first preference is to remove that "#ifdef CONFIG_CHECKPOINT_RESTORE"
altogether.  Note that there are no security issues because this code
is already restricted to "capable(CAP_SYS_RESOURCE)".
Short of that is the proposed patch.

Best Regards,
Amnon.


Andrew Morton wrote:
> 
> On Thu, 21 Feb 2013 12:00:28 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > From: Amnon Shiloh <u3557@miso.sublimeip.com>
> > Subject: prctl: Make PR_SET_MM being depend on own CONFIG_MM_FIELDS_SETTING
> > 
> > ...
> > 
> > Signed-off-by: Amnon Shiloh <u3557@miso.sublimeip.com>
> 
> The "..." makes me sad.
> 
> If/when this patch gets sent for real, please explain the reasons? 
> AFAICT it permits the enabling of prctl(PR_SET_MM) in
> CONFIG_CHECKPOINT_RESTORE=n kernels.  If that was indeed the intent,
> why?
> 
> 

