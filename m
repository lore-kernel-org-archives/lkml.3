Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab3K0SN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 13:13:57 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:42886 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab3K0SNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 13:13:55 -0500
Date: Wed, 27 Nov 2013 11:13:48 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: tty/serial eating \n regression in 3.13-rc1
Message-ID: <20131127181348.GA22723@obsidianresearch.com>
References: <20131126215349.GA4818@obsidianresearch.com>
 <5295E1FB.8090607@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5295E1FB.8090607@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 07:13:47AM -0500, Peter Hurley wrote:
> On 11/26/2013 04:53 PM, Jason Gunthorpe wrote:
> >Hello Peter,
> >
> >I have been testing 3.13-rc1 and I noticed a change in behavior in the
> >tty/serial layer. Specifically I have a login running on serial that
> >presents the usual login:/password: prompt.
> >
> >3.10.12 does this:
> >
> >login: admin
> >password:
> >prompt>
> >
> >While 3.13-rc1 does this:
> >
> >login: admin
> >password: prompt>
> >
> >That is to say, a \n got lost. I have also noticed while using the
> >serial console that '\n's are occasionally lost, and the lossage is
> >highly repeatable and seemingly based on number of chars being output
> >in a burst, eg entering 'foo bar' at a shell prompt might loose the \n,
> >while entering 'foo bar ' will not.
> >
> >I ran a full git bisect search and determined that the attached patch
> >introduced the problem.
> >
> >This seems like a bug - at least the commit comment seems like it
> >should not cause any change in behaviour. I can reproduce it and help
> >debug, if you can give some guidance, I am not a tty layer expert :)
> 
> Hi Jason,
> 
> Thanks for the bisect: this is definitely a bug and not designed behavior.
> But just to be clear here, the error you're seeing is strictly wrt.
> echo output; normal output remains uncorrupted?

I have only seen this in two instances, in each case it happens 100%
of the time, with perfect determinism.

The first is '\n' after 'password:'

The second is '\n' after entering a command in busybox's shell, and in
this case, so far only with one specific command. 'cat enable'.

Curiously 'cat enable ' does not cause the problem, inserting the
extra space seems suspiciously like a buffering math problem?

> Although there are some fixes due for 3.13-rc2 concerning echoes, I
> think this may be a smp weak memory ordering problem.

To clarify, the problematic kernel is running on ARM32 and PPC32 which
are both uniprocessor systems, and it happens 100% of the time, so 
I'd be surprised if it was something as subtle as memory ordering.

The other end of the serial is running Ubuntu's 3.5.0-32-generic,
however I have ssh'd into that machine from one running Ubuntu's
3.11.0-12-generic - and that environment doesn't change.

> When you see the lost '\n', copy /sys/kernel/debug/tracing/trace
> to a file and send it to me (compressed if too big for the lists). Or
> you can send it off-list, if you'd prefer.
> 
> [Apologies if the patch is white-space mangled; my mailer [Thunderbird]
> is dain-bramaged. I think git am will still do the right thing.]

I corrected the whitespace damage by hand, I'm happy with MIME if you
need to send another patch :)

Here is the trace of the login/password sequence, I typed into the
serial the sequence '\nadmin\nadmin\n'

# tracer: nop
#
# entries-in-buffer/entries-written: 7/7   #P:1
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
     kworker/0:1-11    [000] ....    24.912264: __process_echoes: [ttyS0] echoes:0,1 commit:1 head:1
     kworker/0:1-11    [000] ....    25.448097: __process_echoes: [ttyS0] echoes:1,4 commit:4 head:4
     kworker/0:1-11    [000] ....    25.527935: __process_echoes: [ttyS0] echoes:4,5 commit:5 head:5
     kworker/0:1-11    [000] ....    25.591953: __process_echoes: [ttyS0] echoes:5,6 commit:6 head:6
     kworker/0:1-11    [000] ....    25.695950: __process_echoes: [ttyS0] echoes:6,7 commit:7 head:7
     kworker/0:1-11    [000] ....    25.799939: __process_echoes: [ttyS0] echoes:7,8 commit:8 head:8
     kworker/0:1-11    [000] ....    25.928091: __process_echoes: [ttyS0] echoes:8,9 commit:9 head:9

Here is a strace of the terminal program I am running on Ubuntu:

.. passwo
read(3, "r", 1)                         = 1
read(3, "d", 1)                         = 1
read(3, ":", 1)                         = 1
read(3, " ", 1)                         = 1
write(3, "a", 1)                        = 1
write(3, "d", 1)                        = 1
write(3, "m", 1)                        = 1
write(3, "i", 1)                        = 1
write(3, "n", 1)                        = 1
write(3, "\r", 1)                       = 1
read(3, "p", 1)                         = 1
read(3, "r", 1)                         = 1
read(3, "o", 1)                         = 1
.. mpt>

Here is a strace of the login programm running on the PPC

write(1, "password: ", 10)              = 10
ioctl(0, SNDCTL_TMR_START or SNDRV_TIMER_IOCTL_TREAD or TCSETS, {B115200 opost isig icanon -echo ...}) = 0
poll([{fd=0, events=POLLIN}], 1, 60000) = 1 ([{fd=0, revents=POLLIN}])
read(0, "admin\n", 300)                 = 6
ioctl(0, SNDCTL_TMR_START or SNDRV_TIMER_IOCTL_TREAD or TCSETS, {B115200 opost isig icanon echo ...}) = 0
[..]
write(1, "prompt>", 7)

Also, I discovered this sequence, which seems very telling:

login: admin
password: Invalid login.
login: 
a

I entered the sequence 'admin\na\na', which does this in 3.10:

login: admin
password:
Invalid login.
login: a

It looks like The \n that was supposed to precede 'Invalid login' was shifted until
the next input char 'a'. The cursor remains at 'login: X' then when I
type 'a' I get back '\na' - I hope this is clear :)

strace of login for the above:

read(0, "admin\n", 300)                 = 6
write(1, "password: ", 10)              = 10
ioctl(0, SNDCTL_TMR_START or SNDRV_TIMER_IOCTL_TREAD or TCSETS, {B115200 opost isig icanon -echo ...}) = 0
poll([{fd=0, events=POLLIN}], 1, 60000) = 1 ([{fd=0, revents=POLLIN}])
read(0, "a\n", 300)                     = 2
ioctl(0, SNDCTL_TMR_START or SNDRV_TIMER_IOCTL_TREAD or TCSETS, {B115200 opost isig icanon echo ...}) = 0
socket(PF_FILE, SOCK_DGRAM|SOCK_CLOEXEC, 0) = 4
nanosleep({1, 0}, NULL)                 = 0
write(1, "Invalid login.\n", 15)        = 15
write(1, "login: ", 7)          

Terminal is cooked, so the 'a' char doesn't reach login, the '\na'
echo back was created in the kernel.

Looks like the \n stuff when echo is turned off is broken?

Jason
