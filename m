Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaJQPxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:53:23 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46009 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaJQPxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:53:22 -0400
MIME-Version: 1.0
Date: Fri, 17 Oct 2014 11:53:21 -0400
Message-ID: <CACXcFmnjqsDZ0nq2h9ymiUQMczD7yX64COVnz8WsrC38fL1iuQ@mail.gmail.com>
Subject: RFC: Alternative to systemd?
From: Sandy Harris <sandyinchina@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been reading the debates around systemd, haven't reached any firm
conclusion but the criticism that Unix programs should "do one thing
and do it well" certainly resonates with me.

On the other hand, this may be one of those cases where theory and
practice need to differ; more-or-less all the arguments against
systemd's complexity and overly broad scope have been used in debates
over monolithic vs. message-passing kernels. I'd say that in theory
message-passing and smaller programs are obviously better in some
ways, but in practice other considerations may be more important. That
is certainly the case for the kernel; I do not know if it is for
systemd.

All that said, I don't want to re-open the debate here. I would,
though, like to solicit comment on what seems to me a possible simple
alternative that deals with only one of the problems systemd claims to
solve; expressing dependencies that the init process needs to deal
with. There seems to be fairly widespread agreement that the way
sysvinit does this rather clumsy.

We already have a well-established way of dealing with some types of
dependency, in makefiles. Would something with roughly that syntax
work for expressing the dependencies here? Sample lines might be
things like:

sshd: random

!random:
       cat /var/run/random_seed >/dev/urandom

The first line says sshd depends on random; "init sshd" will first
deal with dependencies, so it does the command for random before
starting sshd. Since no command is given for sshd, it defaults to
"sshd &". If arguments are needed, put in a command line. If some
other process depends on sshd it just checks whether it is running via
"ps -C sshd" and, if not, starts it.

"!random:" says, via the "!", that random is not a process that can be
checked with ps -C. We would need to add a data structure to support
another way to check if the process had been run. In actual use' we'd
also have a more complex command than just the cat.

It seems to me this could handle everything needed for init's startup
activities. Adding simple run levels is straightforward; just define
!runlevel3 or !network or whatever with appropriate dependencies. I am
not certain whether or how it might be extended to stop processes when
reducing run level, though.

Comments?
