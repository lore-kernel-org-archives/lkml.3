Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaKCMAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:00:17 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38623 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaKCMAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:00:13 -0500
Message-ID: <54576E48.40800@collabora.co.uk>
Date: Mon, 03 Nov 2014 12:00:08 +0000
From: Simon McVittie <simon.mcvittie@collabora.co.uk>
Organization: Collabora Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Daniel Mack <daniel@zonque.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        "alban.crequy" <alban.crequy@collabora.co.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tom Gundersen <teg@jklm.no>
Subject: Re: kdbus: add code to gather metadata
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org> <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com> <CALCETrVkuKxMMEw3HBEOZoFUuw8PndXtB13+bLWmcp_E34SaFw@mail.gmail.com> <5451FA9B.8070501@zonque.org> <CALCETrWjOS0AHF33zN0Vy1NC1441To7AgNPge3sKCz8bn2d8gg@mail.gmail.com> <54525F32.3040502@zonque.org> <CALCETrV6MLYUQN6mqZbH=FrLyrETVoemtdC05po8+X=6SKQ70A@mail.gmail.com> <5454BE6E.5040507@zonque.org> <CALCETrXxx4juUGA3mwOxq0BtErM0kj7_THxiO5LwCVLzCXnd2A@mail.gmail.com>
In-Reply-To: <CALCETrXxx4juUGA3mwOxq0BtErM0kj7_THxiO5LwCVLzCXnd2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/14 16:19, Andy Lutomirski wrote:
> You can't justify logging fundamentally unverifiable things like the
> command line by saying that you want to know if someone tries to play
> (impossible-to-reliably-detect) games to obscure their command line.

I think kdbus might be mixing up two orthogonal things here.

It has an easy, kernel-checked, race-free way to determine
kernel-mediated credential-like information that cannot be faked or
interfered with (uid, primary gid, other gids?, security label,
capabilities) because these are usable for security decisions, but if
they are *not* received in a kernel-checked, race-free way, then they
are useless.

One concrete example of using non-ucred credential-like information is
that traditional D-Bus can only restrict sysadmin tasks to uid 0 (or a
root-equivalent uid in group sudo/admin/whatever), whereas when systemd
and systemd-logind are run on kdbus, many of their D-Bus methods require
specific capabilities(7): KillUser requires CAP_KILL, PowerOff requires
CAP_SYS_BOOT, and so on. If capabilities(7) are a good thing, then
that's surely a good thing too. (On the other hand, if you think
capabilities(7) are a waste of time, then so is this.)

It also uses the same mechanism as an easy, race-free, but *not*
kernel-checked way to determine bits and pieces that are valuable for
debugging (dbus-monitor etc.), but unsuitable for security decisions,
such as cmdline.

In traditional D-Bus, you can get the uid and pid of a remote process,
but in a debug log you would probably actually prefer to log the cmdline
in addition; yes a malicious user could fake the cmdline, but when
debugging a system problem, information that is known to be forgeable
seems better than no information at all. After all, ps(1) shows the
forgeable cmdline, not just the executable. You can get that by
rummaging in /proc/$pid, but there is a race: if the remote process
exits too soon (a "fire and forget" method call) then you'll never know
who it was. kdbus solves that race, but does not make cmdline unforgeable.

If client libraries wishing to attach their cmdline (or other debug
info) to messages for debugging were required to add it as an
out-of-band KDBUS_ITEM, or as a D-Bus message header inside the payload,
then that would be duplicating work in client libraries that could have
been done centrally, but would still solve the race.

    S

