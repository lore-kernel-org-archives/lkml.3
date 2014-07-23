Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbaGWGOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:14:37 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36982 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbaGWGOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:14:36 -0400
X-AuditID: 85900ec0-cff26b9000001514-88-53cf52c9dd3c
Message-ID: <53CF52C8.2020601@hitachi.com>
Date: Wed, 23 Jul 2014 15:14:32 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH V4 1/5] trace-cmd/listen: Apply the trace-msg protocol
 for communication between a server and clients
References: <20140711005824.25516.24498.stgit@yuno-kbuild.novalocal> <20140711005826.25516.77711.stgit@yuno-kbuild.novalocal> <20140722110444.2e78ad0b@gandalf.local.home>
In-Reply-To: <20140722110444.2e78ad0b@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Thank you for your review.

(2014/07/23 0:04), Steven Rostedt wrote:
> Sorry for taking so long to reply, I've been hacking on the kernel a
> bit and that takes precedence over user tools :-/
>
>
> On Fri, 11 Jul 2014 00:58:26 +0000
> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
>
>> Apply trace-msg protocol for communication between a server and clients.
>>
>> Currently, trace-listen(server) and trace-record -N(client) operate as follows:
>>
>>       <server>                 <client>
>>        listen to socket fd
>>                                connect to socket fd
>>        accept the client
>>        send "tracecmd"
>>                 +------------> receive "tracecmd"
>>                                check "tracecmd"
>>                                send cpus
>>        receive cpus <------------+
>>        print "cpus=XXX"
>>                                send pagesize
>>                                  |
>>        receive pagesize <--------+
>>        print "pagesize=XXX"
>>                                send option
>>                                  |
>>        receive option <----------+
>>        understand option
>>        send port_array
>>                 +------------> receive port_array
>>                                understand port_array
>>                                send meta data
>>        receive meta data <-------+
>>        record meta data
>>                          (snip)
>>        read block
>>       --- start sending trace data on child processes ---
>>
>>       --- When client finishes sending trace data ---
>>                                close(socket fd)
>>        read size = 0
>>        close(socket fd)
>>
>> All messages are unstructured character strings, so server(client) using the
>> protocol must parse the unstructured messages. Since it is hard to
>> add complex contents in the protocol, structured binary message trace-msg
>> is introduced as the communication protocol.
>>
>> By applying this patch, server and client operate as follows:
>>
>>       <server>                 <client>
>>        listen to socket fd
>>                                connect to socket fd
>>        accept the client
>>        send "tracecmd"
>>                 +------------> receive "tracecmd"
>>                                check "tracecmd"
>>                                send "V2\0<MAGIC_NUMBER>\00" as the v2 protocol
>
> Lets change this to "-1V2\0<MAGIC_NUMBER>\00"
>
> The -1 will cause an old server to exit as it will not accept a -1 for
> CPU count. Then you can check if the return of the next read is -1, as
> the client would have disconnected.

Sure.

> The reason I ask this, is because once you send a valid CPU count (and
> unfortunately, 0 happens to be valid :-p, the server side creates a
> file. When you close it, that file stays around as zero length.
>
> By sending -1, the old server will error out and never create a file.

Yes, I also thought this should be fixed.
I'll submit fixed patch.

Thank you,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


