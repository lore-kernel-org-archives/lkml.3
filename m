Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaFJPio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:38:44 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44403 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaFJPim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:38:42 -0400
Message-ID: <5397267E.4060306@hybridcluster.com>
Date: Tue, 10 Jun 2014 18:38:38 +0300
From: Andriy Gapon <andriy.gapon@hybridcluster.com>
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luke Marsden <luke@hybridcluster.com>
Subject: kernel BUG at /build/buildd/linux-3.13.0/fs/namei.c:2987!
Content-Type: text/plain; charset=X-VIET-VPS
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


During filesystem stress testing we've run into the following problem:
kernel BUG at /build/buildd/linux-3.13.0/fs/namei.c:2987!

The line corresponds to line 2989 here:
http://lxr.free-electrons.com/source/fs/namei.c?v=3.13

I have a crash dump and after playing a little bit with 'crash' utility it seems
that path->dentry->d_inode != NULL while inode == NULL.
Looking at the surrounding code I wonder what ensures that dentry->d_inode stays
immutable between lines 2973 and 2989.  I do not see any lock protecting the
dentry.  And, IMHO, it could be possible that the dentry could originally be a
negative entry which is then concurrently morphed into a normal entry before a
check at line 2977 is performed.

What do you think? Thanks!

Some debug data follows. We will gladly provide any additional data that could
be of use.

crash> bt
PID: 4438   TASK: ffff8803fcde97f0  CPU: 2   COMMAND: "python"
 #0 [ffff8804083919e8] machine_kexec at ffffffff8104a732
 #1 [ffff880408391a38] crash_kexec at ffffffff810e6ab3
 #2 [ffff880408391b00] oops_end at ffffffff8171efe8
 #3 [ffff880408391b28] die at ffffffff810171cb
 #4 [ffff880408391b58] do_trap at ffffffff8171e6e0
 #5 [ffff880408391ba8] do_invalid_op at ffffffff81014512
 #6 [ffff880408391c50] invalid_op at ffffffff81727cde
    [exception RIP: do_last+4231]
    RIP: ffffffff811c7787  RSP: ffff880408391d08  RFLAGS: 00010286
    RAX: 0000000000000000  RBX: ffff880408391f2c  RCX: 0000000000000000
    RDX: 0000000000300000  RSI: ffff8801ab856780  RDI: ffff8801ab856780
    RBP: ffff880408391d98   R8: 0000000000000102   R9: ffff880408391ccc
    R10: ffff880405e47020  R11: 0000000000000001  R12: 0000000000018800
    R13: ffff880408391de8  R14: ffff880408391f2c  R15: ffff880408391e40
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffff880408391d00] do_last at ffffffff811c67a7
 #8 [ffff880408391da0] path_openat at ffffffff811c8d7b
 #9 [ffff880408391e38] do_filp_open at ffffffff811ca13a
#10 [ffff880408391f08] do_sys_open at ffffffff811b8859
#11 [ffff880408391f70] sys_openat at ffffffff811b89e4
#12 [ffff880408391f80] tracesys at ffffffff817266bf (via system_call)
    RIP: 00007f88c4cd3550  RSP: 00007fffe824cc08  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: ffffffff817266bf  RCX: ffffffffffffffff
    RDX: 0000000000090800  RSI: 0000000000a62060  RDI: ffffffffffffff9c
    RBP: 00007f88c397c9d0   R8: 00007f88c5227000   R9: 00000000009e4ff0
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff811b89e4
    R13: ffff880408391f78  R14: 00007f88c52a03e3  R15: 0000000000a32028
    ORIG_RAX: 0000000000000101  CS: 0033  SS: 002b

crash> disassemble do_last
Dump of assembler code for function do_last:
...
   0xffffffff811c773b <+4155>:  mov    0x60(%rsp),%rax
   0xffffffff811c7740 <+4160>:  cmp    %rax,0x30(%rsi)
   0xffffffff811c7744 <+4164>:  jne    0xffffffff811c7787 <do_last+4231>
...
   0xffffffff811c7787 <+4231>:  ud2

crash> rd ffff880408391d68
ffff880408391d68:  0000000000000000                    ........

crash> rd ffff8801ab8567b0
ffff8801ab8567b0:  ffff880077a9b078                    x..w....

crash> struct dentry ffff8801ab856780
struct dentry {
  d_flags = 3670212,
  d_seq = {
    sequence = 4
  },
  d_hash = {
    next = 0xffff880290e6c788,
    pprev = 0xffffc90000f28cd0
  },
  d_parent = 0xffff8803e7933a80,
  d_name = {
    {
      {
        hash = 52,
        len = 1
      },
      hash_len = 4294967348
    },
    name = 0xffff8801ab8567b8 "4"
  },
  d_inode = 0xffff880077a9b078,
  d_iname =
"4\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",

  d_lockref = {
    {
      lock_count = 4313317656,
      {
        lock = {
          {
            rlock = {
              raw_lock = {
                {
                  head_tail = 18350360,
                  tickets = {
                    head = 280,
                    tail = 280
                  }
                }
              }
            }
          }
        },
        count = 1
      }
    }
  },
  d_op = 0xffffffffa089cc40,
  d_sb = 0xffff880405e0a800,
  d_time = 4781725256,
  d_fsdata = 0x0,
  d_lru = {
    next = 0xffff8802320ee500,
    prev = 0xffff8801ab856740
  },
  d_u = {
    d_child = {
      next = 0xffff8801ab856750,
      prev = 0xffff8802320ee510
    },
    d_rcu = {
      next = 0xffff8801ab856750,
      func = 0xffff8802320ee510
    }
  },
  d_subdirs = {
    next = 0xffff8801ab856820,
    prev = 0xffff8801ab856820
  },
  d_alias = {
    next = 0x0,
    pprev = 0xffff880077a9b190
  }
}

-- 
Andriy Gapon
