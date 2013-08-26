Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab3HZPLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:11:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11096 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab3HZPLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:07 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=nRXi7Rq_KXAA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=cxZRFzV95EEA:10 a=3nbZYyFuAAAA:8 a=pRqXU8P2i7uQsIi3QhIA:9 a=CjuIK1q_8ugA:10 a=EvKJbDF4Ut8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 26 Aug 2013 11:11:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 08/11] trace-cmd: Apply the trace-msg protocol for
 communication between a server and clients
Message-ID: <20130826111105.5d6504e0@gandalf.local.home>
In-Reply-To: <521AB469.40201@hitachi.com>
References: <20130819094620.26597.79499.stgit@yunodevel>
	<20130819094639.26597.44449.stgit@yunodevel>
	<20130820135658.5a5d6e28@gandalf.local.home>
	<521AB469.40201@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013 10:50:33 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
 
> <Network>
> 0. old server and old client
> Old servers send "tracecmd" as the first message.
> Old clients compare the first 8byte of the first message with "tracecmd".
> 
> 1. new server
> - Send "tracecmd-v2" as the first message.
> - Check the reply message whether the message is "tracecmd-v2" or cpus
>    value.
>    If "tracecmd-v2", the server uses new protocol and wait for the
>    message MSG_TINIT.
>    If cpus value, the server uses old protocol.

That will kill an old client. Yes it only checks the first 8 bytes, but
then it gets back a comma separated list of CPUs. As it uses TCP for
this transaction, the unread "-v2" will end up being read as CPUs by
the client.

> 
> 2. new client
> - Receive the first message.
> - Check the message whether the message is "tracecmd-v2" or not.
>    If "tracecmd-v2", the client sends "tracecmd-v2" to the server. Then,
>    the client sends the message MSG_TINIT.
>    If "tracecmd", the client sends cpus value as the old protocol.
> 

It will have to be the client that determines if the protocol is v2 or
not. Basically, after receiving the "tracecmd" the client can send back
"V2", and then expect the server to reply with "V2" as well. If the
server does not, then it disconnects from the server and then restarts
with the old protocol.

> <Virtio-serial>
> This is new feature, so trace-cmd does not need to keep backward
> compatibility.

Right, the virtio-serial will noly need to be supported by the v2
protocols.

-- Steve
