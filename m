Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196Ab3GPRQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:16:32 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:55740 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab3GPRQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:16:32 -0400
MIME-Version: 1.0
In-Reply-To: <51E57DF3.90304@nod.at>
References: <1373993525-25629-1-git-send-email-artagnon@gmail.com>
 <51E57BC1.4090904@nod.at> <CALkWK0nrDsZiHe2==DQZuHV7id=6gc4UHUj1xXu9jN5cr3SUcQ@mail.gmail.com>
 <51E57DF3.90304@nod.at>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 16 Jul 2013 22:45:51 +0530
Message-ID: <CALkWK0m0LkjFzOUXRQmdDuS+L7mKA87qCMq=MYX6UrnHXi+XRg@mail.gmail.com>
Subject: Re: [PATCH] um/configs: don't use devtmpfs in defconfig
To: Richard Weinberger <richard@nod.at>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> Why does this confuse systemd? systemd has also a dependency on devtmpfs.

See getty@.service, which is a dependency of getty.target:

  # On systems without virtual consoles, don't start any getty. (Note
  # that serial gettys are covered by serial-getty@.service, not this
  # unit
  ConditionPathExists=/dev/tty0

No, systemd does not have a hard dependency on devtmpfs.  See
src/getty-generator/getty-generator.c:

  if (detect_container(NULL) > 0) {
          log_debug("Automatically adding console shell.");

          if (add_symlink("console-getty.service", "console-getty.service") < 0)
                  r = EXIT_FAILURE;

          /* Don't add any further magic if we are in a container */
          goto finish;
  }

I can add a rule for detect_vm() and id = "uml" here, so that um Linux
runs console-getty.service out-of-the-box.  After I do that,
systemd-vconsole-setup.service will fail precisely because systemd
sees a /dev/tty0 and gets confused.
