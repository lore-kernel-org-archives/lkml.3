Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab3HACs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:48:59 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:39002 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab3HACs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:48:57 -0400
MIME-Version: 1.0
In-Reply-To: <51F16CFB.6040603@schaufler-ca.com>
References: <51F16CFB.6040603@schaufler-ca.com>
Date: Thu, 1 Aug 2013 08:18:56 +0530
Message-ID: <CAKTCnzm7eipNPc22=NfOm3X7+ECu1zfckEyjBK+RDY69EZZeDw@mail.gmail.com>
Subject: Re: [PATCH v14 0/6] LSM: Multiple concurrent LSMs
From: Balbir Singh <bsingharora@gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 11:52 PM, Casey Schaufler
<casey@schaufler-ca.com> wrote:
> Subject: [PATCH v14 0/6] LSM: Multiple concurrent LSMs
>
> Version 14 of this patchset is based on v3.10.
> It required significant change from version 13 due to changes
> in the audit code. It came out cleaner, especially in the changes
> to NetLabel. This version supports all existing LSMs running
> together at the same time. The combinations tested most completely
> are:
>
>     apparmor,tomoyo,smack,yama  - Ubuntu
>     apparmor,selinux,smack,yama - Fedora
>

Does this change the way one would develop a new LSM module? I presume
it does not

> I have been unable to figure out how to configure SELinux on
> Ubuntu and TOMOYO on Fedora. That's the only reason the list
> does not include all five LSMs at once. Combining LSMs that
> use networking is tricky, but can be done. There are changes
> coming from AppArmor that might make it even trickier, but
> that's a problem for the future.
>
>
> Change the infrastructure for Linux Security Modules (LSM)s from a
> single vector of hook handlers to a list based method for handling
> multiple concurrent modules. All combinations of existing LSMs
> are supported.
>
> The "security=" boot option takes a comma separated list of LSMs,
> registering them in the order presented. The LSM hooks will be
> executed in the order registered. Hooks that return errors are
> not short circuited. All hooks are called even if one of the LSM
> hooks fails. The result returned will be that of the last LSM
> hook that failed.
>

This is an important design trade-off. From my perspective I think you
might want to revisit this, today it sounds like effective security ==
all hooks process and allow the operation. In this world a lack of
proper policy/setting can make hooks fail. I've not yet looked at the
code, but you might want to revisit this.

> All behavior from security/capability.c has been moved into
> the hook handling.  The security/commoncap functions used
> to get called from the LSM specific code. The handling of the
> capability functions has been moved out of the LSMs and into the
> hook handling.
>
> A level of indirection has been introduced in the handling of
> security blobs. LSMs no longer access ->security fields directly,
> instead they use an abstraction provided by lsm_[gs]et field
> functions.
>
> The notion that "the security context" can be represented as a
> single u32 "secid" does not scale to the case where multiple LSMs
> want to provide "the security context". The XFRM and secmark
> facilities appear unlikely to ever allow for more than the existing
> 32 bit values. The NetLabel scheme might possibly be used to
> represent more than one labeling scheme (CIPSO does allow for
> multiple tags) although there is no plan to do so at this time.
> The SO_PEERSEC scheme is capable of providing information from
> multiple LSMs. Auditing can deal with multiple secids.
>
> The NetLabel, XFRM and secmark facilities are restricted to use
> by one LSM at a time. The SO_PEERSEC facility can provide information
> from multiple LSMs, but existing user space tools don't understand
> that. The default behavior is to assign each of these facilities
> to the first registered LSM that uses them. They can be configured
> for use by any of the LSMs that provide hooks for them. SO_PEERSEC
> can be configured to provide information from all of the LSMs that
> provide hooks.
>
> The /proc/*/attr interfaces are given to one LSM. This can be
> done by setting CONFIG_SECURITY_PRESENT. Additional interfaces
> have been created in /proc/*/attr so that each LSM has its own
> named interfaces. The name of the presenting LSM can be read from
> /sys/kernel/security/present. The list of LSMs being used can be
> read from /sys/kernel/security/lsm.
>
> A "security context" may now contrain information processed by
> more than one LSM. The proper form of a security context identifies
> the information it contains by LSM:
>
>     smack='Pop'selinux='system_u:object_r:etc_r:s0'
>
> A security context without the LSM identifying lsm='<text>' gets
> passed through to all of the LSMs that use a security context. This
> maintains compatability in the case where there is only one LSM
> using the security context.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

Balbir Singh
