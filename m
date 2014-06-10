Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaFJIsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:48:54 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36042 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaFJIst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:48:49 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-38-5396c66e1bd5
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jwboyer@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 0/4] KEYS: validate key trust with owner and builtin keys only
Date: Tue, 10 Jun 2014 11:48:14 +0300
Message-id: <cover.1402387862.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t/xa7p5x6YFGyw6b25x6+9eZot3Tb9Z
	LL4srbM48O4Ji8XsXQ9ZLC7vmsNm8aHnEZvFpxWTmB04PHbOusvuMe3EMhaPB4c2s3i833eV
	zaNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyFl47zVLwV7DixQL9BsZVfF2MnBwSAiYS7Z+f
	M0LYYhIX7q1n62Lk4hASWMoo8WsZjNPJJDGp/xBYFZuAnsSG5h/sIAkRgTZGibatz9hAEswC
	6RKfJvWyg9jCAn4Sex9eYAaxWQRUJZ4/mA9m8wpYSjxe/5wNYp2cxMljk1lBbE4Bd4kj7R/A
	aoQE3CQOHN/FNoGRdwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkED7soNx8TGrQ4wC
	HIxKPLwcOtOChVgTy4orcw8xSnAwK4nw3t0GFOJNSaysSi3Kjy8qzUktPsTIxMEp1cDIlxn1
	dvWs7+/5XQ54/X3UeGGnctyVfU+ChBctkXq+Y/fkfa/XiD99fmB1x+bvdUcaXZ9o9rx9sDZd
	Y35CYKSAzUKjMutQ+dJMWe8mu6aFs50COLTFd+ey9GvnRR4Jvf7sqGSn0NG702T4/x/5lniA
	L7TkBaPi1Wqvd8u2N1m4ms7ZtjRmiruNEktxRqKhFnNRcSIA+HpylBICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mimi,

As you asked ofline , here is possible equivalent and simpler alternative
patches not requiring to have additional keyring.

First patch are irrelevant minor fixes.

Also I want to discuss here Fedora UEFI patches as they are the reason for
the these original patchset.

http://pkgs.fedoraproject.org/cgit/kernel.git/tree/modsign-uefi.patch

They provide functionality to specify MokIgnoreDb variable to limit loading of
UEFI keys only from MOK List, while ignoring DB. This is certainly a good
functionality. But once MODULE_SIG_UEFI is enabled, it looks there is no way
to prevent loading keys from UEFI at all. And this might not be a good default
functionality. Someone might want not allow loading of keys from UEFI unless
kernel parameter is specified to allow it without recompiling the kernel
and disabling MODULE_SIG_UEFI.

Josh, why such design decision was made?

Why not to provide kernel parameter to have more fine-tune control over the
functionality? Unconfigured machines will not have MokIgnoreDb and will
allow to load kernel modules signed with certain undesired keys. In fact,
I beleive, it should be default behavior of the kernel. Bootloader can
enable UEFI functionality by specifing it on the kernel command line.

Second patch allows to overcome keys coming from UEFI for key validation by
specifing owner key id and is an alternative for v5 4/4 patch.

It was also a good idea presented in Mimi's v4 4/4 patch to have possibility
to limit key trust valiation by only builtin keys. Third patch as an alternative.
It uses keys->flags to specify origin of the key, but any additional field could
be added as well.

Both key id and origin verification is done in x509_validate_trust().

Thanks,
Dmitry

Dmitry Kasatkin (3):
  KEYS: fix couple of things
  KEYS: validate key trust only with selected owner key
  KEYS: validate key trust only with builtin keys

Mimi Zohar (1):
  KEYS: define an owner trusted keyring

 Documentation/kernel-parameters.txt      |  5 +++++
 crypto/asymmetric_keys/x509_public_key.c | 35 +++++++++++++++++++++++++++++---
 include/linux/key.h                      |  1 +
 kernel/system_keyring.c                  |  1 +
 4 files changed, 39 insertions(+), 3 deletions(-)

-- 
1.9.1

