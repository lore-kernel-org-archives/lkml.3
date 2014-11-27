Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaK0OBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:01:20 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53519 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaK0OBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:01:16 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-8a-54772ea89ed8
From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Lukasz Pawelczyk <l.pawelczyk@samsung.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Paul Moore <pmoore@redhat.com>,
        Kees Cook <keescook@chromium.org>, Miklos Szeredi <mszeredi@suse.cz>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        Mark Rustad <mark.d.rustad@intel.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Dario Faggioli <raistlin@linux.it>, Alex Thorlton <athorlton@sgi.com>,
        Matthew Dempsky <mdempsky@chromium.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>
Cc: Lukasz Pawelczyk <havner@gmail.com>
Subject: [RFC] LSM/Smack namespace work in progress
Date: Thu, 27 Nov 2014 15:01:05 +0100
Message-id: <1417096866-25563-1-git-send-email-l.pawelczyk@samsung.com>
X-Mailer: git-send-email 1.9.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e/4Nd0VeuUhBvsuClrMWb+GzeLN9enM
	Fve2/WKzWLPsJZvFwQ/3WSyW3Be2eNf0m8Xi/7YWdov/r3Us+h4HWZzYfJ/R4ufKXYwWZ7pz
	Lc5MWshksfl7B5vF5V1z2Cw+9Dxis5jz9i2bxdXp69ktLh1YwGRx6fddZouVn2+zWGzd38po
	cbz3AJPF52u/2C2u393CbNG2ZCOTxbnG5ywW5y+cY7e4vHUms8X5v8dZHeQ9ZjX0snnMbrjI
	4rFz1l12jwWbSj2u7Y702LVtJ5PH5hVaHov3vGTyODHjN4tH2/J9LB6Tbyxn9Pj49BaLx8l5
	P9k83u+7yubRt2UVo8fR/YvYAkSjuGxSUnMyy1KL9O0SuDKuTm1iLTjqXrHp7kemBsaPFl2M
	HBwSAiYSUzfkdTFyApliEhfurWfrYuTiEBJYyihx6Pp3Jginl0li7bpPLCBVbAIGEt8v7GUG
	SYgIrOSUuLfnADNIgllAXWLp7GawImEBY4kFJ5+yg9gsAqoSx77/ZQWxeQXcJT70d7FCrJOT
	6N32hnkCI/cCRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCGR93UH49JjVocYBTgYlXh4
	GW6VhQixJpYVV+YeYpTgYFYS4TXSKQ8R4k1JrKxKLcqPLyrNSS0+xMjEwSnVwBhu4300qngx
	G/c1vy9Skw4q//dq8ipyMOsytUq+9GOp8jqFG3/+cLTvio5+1C7+s/3GbQaeuvz/j/d2VO1t
	ZMuQSeSXuO+t7+clufGKy5Kt5TOffKu2E2URmzp387tu1US74C/in15HrfY+veULx5qYTb6P
	k385nMsUecCU99XsIXeibaWhtxJLcUaioRZzUXEiAPMZ0WiaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm in the process of writing a Smack namespace that is based on LSM
namespace hooks that I'm implementing as well. The work is almost
finished and the patches are currently undergoing an internal review.

Smack namespace was designed with collaboration of Smack maintainer
Casey Schaufler.

Meanwhile I'd like to request some comments about the LSM hooks patch
I have here. I realize that maybe it's difficult to evaluate this
without live usage example (that Smack namespace will server as) but
at this point any comments would be great.

Smack namespace have been successfully implemented using these hooks
and to put some context to it I paste here a preliminary kernel
documentation on what Smack namespace wants to achieve.

LSM hooks themselves are documented in the security.h file inside the
patch.


======================================================================

=== What is Smack namespace ===

Smack namespace was developed to make it possible for Smack to work
nicely with Linux containers where there is a full operating system
with its own init inside the namespace. Such a system working with
Smack expects to have at least partially working SMACK_MAC_ADMIN to be
able to change labels of processes and files. This is required to be
able to securely start applications under the control of Smack and
manage their access rights.

It was implemented using LSM namespace hooks that were developed
together with Smack namespace.


=== Design ideas ===

"Smack namespace" is rather "Smack labels namespace" as not the whole
MAC is namespaced, only the labels. There is a great analogy between
Smack labels namespace and the user namespace part that remaps UIDs.

The idea is to create a map of labels for a namespace so the namespace
is only allowed to use those labels. Smack rules are always the same
as in the init namespace (limited only by what labels are mapped) and
cannot be manipulated from the child namespace. The map is actually
only for labels' names. The underlying structures for labels remain
the same. The filesystem also stores the "unmapped" labels from the
init namespace.

Let's say we have those labels in the init namespace:
label1
label2
label3

and those rules:
label1 label2 rwx
label1 label3 rwx
label2 label3 rwx

We create a map for a namespace:
label1 -> mapped1
label2 -> mapped2

This means that 'label3' is completely invisible in the namespace. As if
it didn't exist. All the rules that include it are ignored.

Effectively in the namespace we have only one rule:
mapped1 mapped2 rwx

Which in reality is:
label1 label2 rwx

All requests to access an object with a 'label3' will be denied. If it
ever comes to a situation where 'label3' would have to be printed
(e.g. reading an exec or mmap label from a file to which we have
access) then huh sign '?' will be printed instead.

All the operations in the namespace on the remaining labels will have
to be performed using their mapped names. Things like changing own
process's label, changing filesystem label. Labels will also be
printed with their mapped names.

You cannot import new labels in a namespace. Every operation that
would do so in an init namespace will return an error in the child
namespace. You cannot assign an unmapped or not existing label to an
object. You can only operate on labels that have been explicitly
mapped.


=== Capabilities ===

Smack related capabilities work to some extent. In several places
where capabilities are checked compatibility with Smack namespace has
been introduced. Capabilities are of course also limited to operate
only on mapped labels.

CAP_MAC_OVERRIDE works fully, will allow you to ignore Smack access
rules, but only between objects that have labels mapped. So in the
example above having this CAP will allow e.g. label2 to write to
label1, but will not allow any access to label3.

With CAP_MAC_ADMIN the following operations has been allowed inside
the namespace:
- setting and removing xattr on files, including the security ones
- setting process's own label (/proc/self/attr/current)
- mounting in a privileged Smack mode, which means one can specify
  additional mount options like: smackfsdef, smackfsfloor etc.

Again this is also allowed only on the mapped labels. Labels on the
filesystem will be stored in unmapped form so they are preserved
through reboots.

Such a namespace construct allows e.g. systemd (that supports Smack)
working in a container to assign labels properly to daemons and other
processes.


=== Usage ===

Smack namespace is written using LSM hooks. It's a normal namespace
that behaves similarly to all the others existing right now.

You can create a new Smack/LSM namespace using e.g. unshare(). The
labels' map is in a file /proc/$PID/attr_map. By default it's empty so
it has to be filled before any other operation is performed (as no
mapped labels equals no labels inside a namespace equals all the
operations will not be permitted).

Due to the way Smack works only CAP_MAC_ADMIN from the init_user_ns is
allowed to fill the map. That means that for now an unprivileged user
in theory is allowed to create the namespace but it will not allow for
any operation inside. An administrator intervention to fill the
labels' maps is required. The possibility similar to user namespace
where a process could at least remap its own label will be
re-investigated later on.

The attr_map write format is:
unmapped_label mapped_label

When reading the file it shows a current map for a namespace the
process in question is in in the format:
unmapped_label -> mapped_label

Writing to the map file is not disabled after the first write as in
user namespace. For Smack we have no means to map ranges of labels,
hence it can really be advantageous to be able to expand the map later
on. But you can only add to the map. You cannot remove already mapped
labels. You cannot change the already existing mappings. Also mappings
has to be 1-1. All tries to create a map where either the unmapped or
the mapped label already exists in the map will be denied.

setns is also allowed, but the label of a process that is calling
setns has to be already mapped in the target Smack namespace for the
call to succeed.


=== Special labels ===

Smack is using some special labels that have built-in rules. Things
like floor '_', dash '^', star '*', etc. Those labels are not
automatically mapped to the namespace. Moreover, you can choose to map
a different label from the init namespace to behave e.g. like floor
inside the namespace.

Let's say we have no rules and those labels in the init namespace:
_
floor_to_be
label

Both label and floor_to_be can read objects with _. But they have no
access rights to each other.

Now let's create a map like this:
_             ordinary_label
floor_to_be   _
label         mapped

Right now label 'mapped' can read label '_' which means that
effectively inside this namespace label 'label' has gained read access
to the 'floor_to_be'. The label 'ordinary_label' is exactly it, an
ordinary label that the built-in rules no longer apply to inside the
namespace.

To sum up special labels in the namespace behave the same as in the
init namespace. Not the original special labels though, but the ones
we map to specials. This is the only case where a namespace can have
access rights the init namespace does not have (like the 'label' to
'floor_to_be' in the example above).


=== Current limitations ===

The Smack namespace is not hierarchical yet. It is possible to create
a Smack namespace within the Smack namespace but the creating
namespace will be denied the right to fill the map. Only CAP_MAC_ADMIN
in the init_user_ns can do that now. When hierarchy will be
implemented the process creating another namespace will be allowed to
map only labels that it has permission to itself (those that it has
in its own map).

Special files inside the virtual smackfs needs to be reviewed whether
it's beneficial to have some of their functionality namespaced as well
(e.g. onlycap, syslog. ambient, etc). This would increase
CAP_MAC_ADMIN privileges inside the namespace.




Lukasz Pawelczyk (1):
  lsm: namespace hooks

 fs/proc/namespaces.c          |   4 ++
 include/linux/lsm_namespace.h |  68 +++++++++++++++++++
 include/linux/nsproxy.h       |   2 +
 include/linux/proc_ns.h       |   2 +
 include/linux/security.h      |  80 +++++++++++++++++++++++
 include/uapi/linux/sched.h    |   3 +-
 kernel/fork.c                 |   2 +-
 kernel/nsproxy.c              |  22 ++++++-
 security/Kconfig              |   8 +++
 security/Makefile             |   1 +
 security/capability.c         |  33 ++++++++++
 security/lsm_namespace.c      | 147 ++++++++++++++++++++++++++++++++++++++++++
 security/security.c           |  42 ++++++++++++
 13 files changed, 408 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/lsm_namespace.h
 create mode 100644 security/lsm_namespace.c

-- 
1.9.3

