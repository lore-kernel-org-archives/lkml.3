Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaF0TPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:15:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:28794 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751304AbaF0TPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:15:00 -0400
Date: Fri, 27 Jun 2014 15:14:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 1/2] trace-cmd: [BUGFIX] Initialize handle->options list
 in tracecmd_attach_cpu_data_fd()
Message-ID: <20140627151458.27008111@gandalf.local.home>
In-Reply-To: <20140624022343.14037.69077.stgit@yuno-kbuild.novalocal>
References: <20140624022340.14037.63549.stgit@yuno-kbuild.novalocal>
	<20140624022343.14037.69077.stgit@yuno-kbuild.novalocal>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014 02:23:43 +0000
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:

> This patch initializes handle->options list in tracecmd_attach_cpu_data_fd().
> 
> When recorder sends trace data via network, server recording process is
> killed by SIGSEGV from the patch 71484a0854f7. This is because add_options()
> uses handle->options list from the patch, but tracecmd_attach_cpu_data_fd()
> calling add_options() does not initialize the list in spite of allocation of
> new handle. As the result, the server recording process will be killed because
> handle->options is cleared to zero in tracecmd_attach_cpu_data_fd().
> 
> <How to test>
> 1. Execute network(listen) server
>  # trace-cmd listen -p 12345
> 
> 2. Execute network client
>  # trace-cmd record -e sched* -N <server IP>:12345
> 
> 3. Stop the record on client
>  ^C
> 
>  Here, network server should output a line "CPUX data recorded at offset=XXXX",
>  but current network server aborts silently.
> 
>  Moreover the client's per-cpu files are separated. (Normally those files
>  are merged into one trace file.)
> 
> 4. Confirm error on network server
>  #  dmesg | tail -1
> [18551.537113] trace-cmd[23073]: segfault at ffffffffffffffe8 ip 0000000000432fd1 sp 00007fffffa4caa0 error 5 in trace-cmd[400000+47000]
> 
>  After we would introduce this patch, the server will be fully able to output
>  the client's tracing data and we will not get this error.
> 
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Applied thanks! I also added a test to my trace-cmd test suite to check
trace-cmd listen.

-- Steve


> ---
>  trace-output.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/trace-output.c b/trace-output.c
> index ed81466..b033baa 100644
> --- a/trace-output.c
> +++ b/trace-output.c
> @@ -1202,6 +1202,7 @@ int tracecmd_attach_cpu_data_fd(int fd, int cpus, char * const *cpu_data_files)
>  	handle->pevent = tracecmd_get_pevent(ihandle);
>  	pevent_ref(pevent);
>  	handle->page_size = tracecmd_page_size(ihandle);
> +	list_head_init(&handle->options);
>  
>  	if (tracecmd_append_cpu_data(handle, cpus, cpu_data_files) >= 0)
>  		ret = 0;

