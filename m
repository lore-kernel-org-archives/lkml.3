Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab3DWQE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:04:26 -0400
Received: from nm6-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.114]:34138
	"EHLO nm6-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757134Ab3DWQEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:04:21 -0400
X-Yahoo-Newman-Id: 949471.49765.bm@smtp102.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pkJ.L3UVM1miACzgqoSC_32jplqe70dXztN1ZwelvsAaGnh
 _1FAQM5qRz.nqkewuSx2DMH24j4cMMAgGNUDS_YjETpV6mphdWyVWLW61QRo
 Z4jp5GR.2Zv.oxKg2anHj7o3GyHdHohZtyVmfW1TxC8kCyXoB1taG8W4uEz8
 bRlgR6bDuWexNAsO8FvG.7zUQHmLc4Mf07_jhbbb.PEZunPsdWnw2xpTxhlw
 a5Qp0fPq3wMB4_xaDKYTwEKlta21C37loMr9FYVoIodePpPxdn.onl.b_Tpi
 931EGPyB.yP79anJ5FKN5LRvqxKks5tlr6BZFCyIbMNVJfHgaXbtGg9Y8reb
 OKrBftdlYEH699QM58MtDyXBh9xn50ewBof.vowYofJFZfYQYuNuVrA1SYMB
 TlHe8ciF44rD8Cg8yFbFCfSqXH6PW1ZqsWMruEfQ5SY63Ntgh1AXyKiIMwGL
 I
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp102.biz.mail.ne1.yahoo.com with SMTP; 23 Apr 2013 09:04:05 -0700 PDT
Message-ID: <5176B0F6.7080506@schaufler-ca.com>
Date: Tue, 23 Apr 2013 09:04:06 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>
CC: John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH v13 0/9] LSM: Multiple concurrent LSMs
References: <5176ABB7.5080300@schaufler-ca.com>
In-Reply-To: <5176ABB7.5080300@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v13 0/9] LSM: Multiple concurrent LSMs

Change the infrastructure for Linux Security Modules (LSM)s from a
single vector of hook handlers to a list based method for handling
multiple concurrent modules.

The "security=" boot option takes a comma separated list of LSMs,
registering them in the order presented. The LSM hooks will be
executed in the order registered. Hooks that return errors are
not short circuited. All hooks are called even if one of the LSM
hooks fails. The result returned will be that of the last LSM
hook that failed.

All behavior from security/capability.c has been moved into
the hook handling.  The security/commoncap functions used
to get called from the LSM specific code. The handling of the
capability functions has been moved out of the LSMs and into the
hook handling.

A level of indirection has been introduced in the handling of
security blobs. LSMs no longer access ->security fields directly,
instead they use an abstraction provided by lsm_[gs]et field
functions.

The notion that "the security context" can be represented as a
single u32 "secid" does not scale to the case where multiple LSMs
want to provide "the security context".  There are two types of
use for secids, logging and networking. Logging is addressed by
replacing the secid with a set of secids. Networking is addressed
by allocating each scheme to a specific LSM.

The NetLabel, XFRM and secmark facilities are restricted to use
by one LSM at a time. This is due to limitations of the underlying
networking mechanisms. The good news is that viable configurations
can be created. The bad news is that the complexity of configuring
a system is necessarily increased.

The /proc/*/attr interfaces are given to one LSM. This can be
done by setting CONFIG_SECURITY_PRESENT. Additional interfaces
have been created in /proc/*/attr so that each LSM has its own
named interfaces.

A "security context" may now contrain information processed by
more than one LSM. The proper form of a security context identifies
the information it contains by LSM:

	smack='Pop'selinux='system_u:object_r:etc_r:s0'

A security context without the LSM identifying lsm='<text>' gets
passed through to all of the LSMs that use a security context. This
maintains compatability in the case where there is only one LSM
using the security context.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 Documentation/security/LSM.txt                     |   39 +-
 drivers/usb/core/devio.c                           |   10 +-
 fs/proc/base.c                                     |   29 +-
 fs/sysfs/dir.c                                     |    3 +-
 fs/sysfs/inode.c                                   |    5 +-
 fs/sysfs/sysfs.h                                   |    7 +-
 fs/xattr.c                                         |    8 +-
 include/linux/audit.h                              |    9 +-
 include/linux/cred.h                               |    3 +-
 include/linux/lsm.h                                |  167 ++
 include/linux/sched.h                              |    2 +-
 include/linux/security.h                           |  378 +++-
 include/net/af_unix.h                              |    3 +-
 include/net/netlabel.h                             |    3 +-
 include/net/scm.h                                  |    8 +-
 include/net/xfrm.h                                 |    4 +-
 kernel/audit.c                                     |   94 +-
 kernel/audit.h                                     |    4 +-
 kernel/auditfilter.c                               |   21 +-
 kernel/auditsc.c                                   |   80 +-
 kernel/cred.c                                      |    6 +-
 kernel/signal.c                                    |    6 +-
 net/ipv4/ip_sockglue.c                             |    8 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   11 +-
 net/netfilter/nf_conntrack_netlink.c               |   24 +-
 net/netfilter/nf_conntrack_standalone.c            |   11 +-
 net/netfilter/xt_SECMARK.c                         |    4 +-
 net/netlabel/netlabel_kapi.c                       |   37 +-
 net/netlabel/netlabel_unlabeled.c                  |   22 +-
 net/netlabel/netlabel_user.c                       |    4 +-
 net/netlabel/netlabel_user.h                       |   61 +-
 net/unix/af_unix.c                                 |   17 +-
 net/xfrm/xfrm_user.c                               |   16 +-
 security/Kconfig                                   |  176 +-
 security/Makefile                                  |    3 +-
 security/apparmor/context.c                        |   10 +-
 security/apparmor/domain.c                         |   19 +-
 security/apparmor/include/context.h                |   13 +-
 security/apparmor/lsm.c                            |   68 +-
 security/capability.c                              | 1105 -----------
 security/commoncap.c                               |    6 -
 security/inode.c                                   |   79 +-
 security/integrity/ima/ima_policy.c                |    7 +-
 security/security.c                                | 2014 ++++++++++++++++----
 security/selinux/hooks.c                           |  412 ++--
 security/selinux/include/objsec.h                  |    2 +
 security/selinux/include/xfrm.h                    |    2 +-
 security/selinux/netlabel.c                        |   17 +-
 security/selinux/selinuxfs.c                       |    6 +-
 security/selinux/xfrm.c                            |    9 +-
 security/smack/smack.h                             |   15 +-
 security/smack/smack_access.c                      |    2 +-
 security/smack/smack_lsm.c                         |  474 +++--
 security/smack/smackfs.c                           |   56 +-
 security/tomoyo/common.h                           |    6 +-
 security/tomoyo/domain.c                           |    2 +-
 security/tomoyo/securityfs_if.c                    |    9 +-
 security/tomoyo/tomoyo.c                           |   49 +-
 security/yama/Kconfig                              |    7 -
 security/yama/yama_lsm.c                           |   35 +-
 60 files changed, 3357 insertions(+), 2350 deletions(-)

