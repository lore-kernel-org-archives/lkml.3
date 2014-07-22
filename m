Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbaGVPEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:04:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:26073 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752626AbaGVPEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:04:46 -0400
Date: Tue, 22 Jul 2014 11:04:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        Aaron Fabbri <aaronx.j.fabbri@intel.com>
Subject: Re: [PATCH V4 1/5] trace-cmd/listen: Apply the trace-msg protocol
 for communication between a server and clients
Message-ID: <20140722110444.2e78ad0b@gandalf.local.home>
In-Reply-To: <20140711005826.25516.77711.stgit@yuno-kbuild.novalocal>
References: <20140711005824.25516.24498.stgit@yuno-kbuild.novalocal>
	<20140711005826.25516.77711.stgit@yuno-kbuild.novalocal>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for taking so long to reply, I've been hacking on the kernel a
bit and that takes precedence over user tools :-/


On Fri, 11 Jul 2014 00:58:26 +0000
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:

> Apply trace-msg protocol for communication between a server and clients.
> 
> Currently, trace-listen(server) and trace-record -N(client) operate as follows:
> 
>      <server>                 <client>
>       listen to socket fd
>                               connect to socket fd
>       accept the client
>       send "tracecmd"
>                +------------> receive "tracecmd"
>                               check "tracecmd"
>                               send cpus
>       receive cpus <------------+
>       print "cpus=XXX"
>                               send pagesize
>                                 |
>       receive pagesize <--------+
>       print "pagesize=XXX"
>                               send option
>                                 |
>       receive option <----------+
>       understand option
>       send port_array
>                +------------> receive port_array
>                               understand port_array
>                               send meta data
>       receive meta data <-------+
>       record meta data
>                         (snip)
>       read block
>      --- start sending trace data on child processes ---
> 
>      --- When client finishes sending trace data ---
>                               close(socket fd)
>       read size = 0
>       close(socket fd)
> 
> All messages are unstructured character strings, so server(client) using the
> protocol must parse the unstructured messages. Since it is hard to
> add complex contents in the protocol, structured binary message trace-msg
> is introduced as the communication protocol.
> 
> By applying this patch, server and client operate as follows:
> 
>      <server>                 <client>
>       listen to socket fd
>                               connect to socket fd
>       accept the client
>       send "tracecmd"
>                +------------> receive "tracecmd"
>                               check "tracecmd"
>                               send "V2\0<MAGIC_NUMBER>\00" as the v2 protocol

Lets change this to "-1V2\0<MAGIC_NUMBER>\00"

The -1 will cause an old server to exit as it will not accept a -1 for
CPU count. Then you can check if the return of the next read is -1, as
the client would have disconnected.

The reason I ask this, is because once you send a valid CPU count (and
unfortunately, 0 happens to be valid :-p, the server side creates a
file. When you close it, that file stays around as zero length.

By sending -1, the old server will error out and never create a file.

-- Steve

>       receive "V2" <------------+
>       check "V2"
>       read "<MAGIC_NUMBER>\00"
>       send "V2"
>             +---------------> receive "V2"
>                               check "V2"
>                               send cpus,pagesize,option(MSG_TINIT)
>       receive MSG_TINIT <-------+
>       print "cpus=XXX"
>       print "pagesize=XXX"
>       understand option
>       send port_array
>                +--MSG_RINIT-> receive MSG_RINIT
>                               understand port_array
>                               send meta data(MSG_SENDMETA)
>       receive MSG_SENDMETA <----+
>       record meta data
>                          (snip)
>                               send a message to finish sending meta data
>                                 |                           (MSG_FINMETA)
>       receive MSG_FINMETA <-----+
>       read block
>      --- start sending trace data on child processes ---
> 
>      --- When client finishes sending trace data ---
>                               send MSG_CLOSE
>       receive MSG_CLOSE <-------+
>       close(socket fd)        close(socket fd)
> 
