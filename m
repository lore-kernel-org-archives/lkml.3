Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851AbaJ3Sqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 14:46:55 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33927 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760769AbaJ3Sqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 14:46:53 -0400
Message-ID: <54528798.40107@collabora.co.uk>
Date: Thu, 30 Oct 2014 18:46:48 +0000
From: Simon McVittie <simon.mcvittie@collabora.co.uk>
Organization: Collabora Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Djalal Harouni <tixxdz@opendz.org>, Andy Lutomirski <luto@amacapital.net>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        "alban.crequy" <alban.crequy@collabora.co.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tom Gundersen <teg@jklm.no>
Subject: Re: kdbus: add code for buses, domains and endpoints
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org> <8738a6w6kv.fsf@x220.int.ebiederm.org> <20141030095854.GA4716@dztty> <87wq7hiwjb.fsf@x220.int.ebiederm.org> <20141030144855.GA9705@dztty> <CALCETrXeNQUuwiyaJrbbbZUrSW3NTucRgpg0kKEuS3yszP-09w@mail.gmail.com> <20141030180813.GA11850@dztty>
In-Reply-To: <20141030180813.GA11850@dztty>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/10/14 18:08, Djalal Harouni wrote:
> So, this is similar to AF_UNIX sockets. For them there's SCM_CREDENTIALS
> and SO_PEERCRED. The former uses credentials at the time of when
> messages are being sent, the latter uses the credentials at the time
> when when the connection was initially established.

Please note that dbus-daemon, the reference implementation of D-Bus,
does not actually ever use SCM_CREDENTIALS on its AF_UNIX sockets. We
prefer to use Linux's SO_PEERCRED, or the platform's closest available
equivalent if there is one. dbus-daemon has methods (RPC calls) to get a
specified peer's uid, pid or LSM data (e.g. SELinux context), but those
methods return the value that was true when the connection was opened or
shortly afterwards, not the value that is true right now. I believe the
plan is that kdbus has ioctls that are equivalent to those RPC calls,
but without needing to wait for asynchronous socket events to get an answer.

The reason I say "or shortly afterwards" is that for the benefit of
platforms where the "best" credentials transfer mechanism behaves like
Linux SCM_CREDENTIALS, such as FreeBSD's SCM_CREDS, the beginning of a
D-Bus protocol stream is that the client sends '\0' to dbus-daemon,
accompanied by SCM_CREDS or whatever if the platform needs it. On Linux
we just send a plain '\0' with no out-of-band data at that point.

The only out-of-band data we send with individual D-Bus RPC messages
later in the connection's lifetime is for fd-passing (SCM_RIGHTS).

It would be a perfectly reasonable feature request to have individual
D-Bus messages that contain proof that, *at the time of sending*, the
sender possessed a given uid/pid/gid/capability/whatever, but we do not
currently have that feature. It would be reasonable for kdbus to have
that feature even though traditional D-Bus doesn't, and it's entirely
possible that it is a feature that would be of benefit for e.g. systemd,
but it is not required for feature parity with traditional D-Bus over
AF_UNIX; it should be included in kdbus, or not, on its own merits.

    S

