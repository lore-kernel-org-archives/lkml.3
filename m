Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab3GYS7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:59:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2231 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab3GYS7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:59:04 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=_6S4gJz81GoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=UirpL7NoV14A:10 a=bLUb8Y6-K0ZtXP1s44IA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374778741.3356.181.camel@gandalf.local.home>
Subject: Re: __ftrace_hash_rec_update FTRACE_WARN_ON.
From: Steven Rostedt <rostedt@goodmis.org>
To: Steve Hodgson <steve@purestorage.com>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Date: Thu, 25 Jul 2013 14:59:01 -0400
In-Reply-To: <CADHUQJ4yweA4zNKqtsq=iQkX+o6UmA-dwWV1d-0SdJbpGtZR5A@mail.gmail.com>
References: <20130705142629.GA325@redhat.com>
	 <1373036034.22688.155.camel@gandalf.local.home>
	 <20130724160422.GA3641@logfs.org>
	 <1374715444.3356.163.camel@gandalf.local.home>
	 <CADHUQJ4yweA4zNKqtsq=iQkX+o6UmA-dwWV1d-0SdJbpGtZR5A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 22:46 -0700, Steve Hodgson wrote:

> No, nothing so complicated.
> 
> I added symbols from a kernel module into
> /sys/kernel/debug/tracing/set_ftrace_filter, enabled tracing, then
> unloaded the kernel module.
> 
> Which I'll admit is a stupid thing to do. I was then punished for my
> stupidity by being unable to use ftrace until the next reboot.

It's not stupid. ftrace should be robust enough to handle this. Anyway,
thank you, I found a reproducer.

Removing the module isn't good enough. You need to load it again.

 # cd /sys/kernel/debug/tracing
 # cat set_ftrace_filter
#### all functions enabled ####
 # modprobe uinput
 # echo uniput_release > set_ftrace_filter
 # cat set_ftrace_filter
uinput_release [uinput]
 # rmmod uinput
 # cat set_ftrace_filter
 # # note this is empty
 # modprobe uinput
 # cat set_ftrace_filter
uinput_release [uinput]
 # # '<it magically appeared>'
 # echo > set_ftrace_filter
[BOOM]

Now that I know what's the problem, it shouldn't be too hard to fix.

Thanks!

-- Steve


