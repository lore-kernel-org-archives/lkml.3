Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbaHaJDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 05:03:38 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:65403 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaHaJDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 05:03:36 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, falcon@meizu.com,
        tiwai@suse.de, tj@kernel.org, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com, akpm@linux-foundation.org,
        penguin-kernel@i-love.sakura.ne.jp, joseph.salisbury@canonical.com,
        bpoirier@suse.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v1 0/3] driver-core: add asynch module loading support
Date: Sun, 31 Aug 2014 02:03:17 -0700
Message-Id: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

While reviewing Wu Zhangjin's solution to async probe [0] and his
ideas on creating async groups I decided to try following the init
levels on the kernel to try to help with synchronization at least
on some level. This borrows ideas discussed with the kthread_create()
solution [1] and also simplifies the idea of how we should be grouping
async calls between drivers.

A few things worth mentioning. I decided to go down a generic solution as
if we ever wanted to bring asynchrnonization behaviour below modules
this would allow folks to start testing this without much effort. It
allows asynchronous calls to upkeep the order already set in place
for built-in code. If one wanted to eventually venture down below
that path we'd need to add respective exit calls for each level, as
right now we just assume that every level should use module_exit().
SmPL grammer could be used to easily tidy this up, for example on
the subsys_init():

@ subsys_found @
expression fn_init;
declarer name subsys_initcall;
@@

  subsys_initcall(fn_init);                                                     

@ subsys_exit_found depends on subsys_found @
expression fn_exit;
declarer name module_exit;
declarer name subsys_exitcall;
@@                                                                              
                                                                                
- module_exit(fn_exit);
+ subsys_exitcall(fn_exit);

And so on. The second thing to note is that when an asynchronous
call is used we don't want to free the init data as otherwise
async_run_entry_fn() will run into a missing init routine. SmPL
could still be used to convert basic __init data out if this is
needed, however if the init routine also used other init data
we'd also have to remove the other __init data used. It could
in theory be possible to do a witch hunt to write this in grammar
but for now only a simple conversion on the init side is recommended
as reflected in the SmPL below and manual inspection after that.
Another option as suggested by Julia to me was to consider an
__init_asynch which we could reap later. This is of course if
we go down this generic path.

@ module_init_found @
identifier f;
declarer name module_init;
declarer name module_init_async;
@@

-   module_init(f);
+   module_init_async(f);

@ modify_decl depends on module_init_found @
identifier module_init_found.f;
@@

- int f
+ int f
    (...) { ... }


@ module_exit_found depends on module_init_found @
identifier fn_exit;
declarer name module_exit;
declarer name module_exit_async;
@@

- module_exit(fn_exit);
+ module_exit_async(fn_exit);

Although not visible the above int f does remove the __init...

If generalizing an async solution is not desirable in the
long run for things other than modules than a bool should
be easy to use to figure if probe should run async'd or not.
Grouping however still becomes a question then, and this is
why I went with this approach as it aligns itself more closely
to the kernel init levels and that should be well tested. In
theory it could even be possible to use a similar strategy to
asynch on per init level when built-in using a similar strategy
but these would have to be separate.

Let me know which way to swing, and if we do a probe bool on
the module, please consider the grouping question.

[0] https://lkml.org/lkml/2014/8/14/11
[1] http://lists.freedesktop.org/archives/systemd-devel/2014-August/022156.html

Luis R. Rodriguez (3):
  driver-core: split module_init() and module_exit()
  async: move synchronous caller into a helper
  async: add driver asynch levels

 include/linux/async.h |  4 +++
 include/linux/init.h  | 77 ++++++++++++++++++++++++++++++++++++++-------------
 kernel/async.c        | 55 +++++++++++++++++++++++++++++++-----
 3 files changed, 109 insertions(+), 27 deletions(-)

-- 
2.0.3

