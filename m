Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaCNKQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:16:57 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45514 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaCNKQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:16:55 -0400
Date: Fri, 14 Mar 2014 17:40:08 +0800
From: Shaohua Li <shli@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        agk@redhat.com
Subject: Re: [patch v3]DM: dm-insitu-comp: a compressed DM target for SSD
Message-ID: <20140314094008.GA2386@kernel.org>
References: <20140218101304.GA24889@kernel.org>
 <20140307075733.GB21790@kernel.org>
 <20140310135256.GA28665@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <20140310135256.GA28665@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2014 at 09:52:56AM -0400, Mike Snitzer wrote:
> On Fri, Mar 07 2014 at  2:57am -0500,
> Shaohua Li <shli@kernel.org> wrote:
> 
> > ping!
> 
> Hi,
> 
> I intend to get dm-insitu-comp reviewed for 3.15.  Sorry I haven't
> gotten back with you before now, been busy tending to 3.14-rc issues.
> 
> I took a quick first pass over your code a couple weeks ago.  Looks to
> be in great shape relative to coding conventions and the more DM
> specific conventions.  Clearly demonstrates you have a good command of
> DM concepts and quirks.
> 
> But one thing that would really help get dm-insitu-comp into 3.15 is to
> show that the code is working as you'd expect.  To that end, it'd be
> great if you'd be willing to add dm-insitu-comp support to the
> device-mapper-test-suite, see:
> https://github.com/jthornber/device-mapper-test-suite
> 
> I recently added barebones/simple dm-crypt support, see:
> https://github.com/jthornber/device-mapper-test-suite/commit/c865bcd4e48228e18626d94327fb2485cf9ec9a1
> 
> But It may be that activation/test code for the other targets (e.g. thin
> or cache) are more useful examples to follow for implemnting
> dm-insitu-comp stack activation, see:
> https://github.com/jthornber/device-mapper-test-suite/blob/master/lib/dmtest/pool-stack.rb
> https://github.com/jthornber/device-mapper-test-suite/blob/master/lib/dmtest/cache_stack.rb
> 
> All said, implementing dm-insitu-comp support for dmts (including some
> tests that establish it is working as intended) isn't a hard requirement
> for getting the target upstream but it would _really_ help.

Ok, I added some simple tests in the test suites.

Thanks,
Shaohua

--Nq2Wo0NMKNjxTN9z
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="comp.patch"

---
 lib/dmtest/suites/insitu-comp.rb                  |    1 
 lib/dmtest/tests/insitu-comp/insitu-comp_tests.rb |  120 ++++++++++++++++++++++
 2 files changed, 121 insertions(+)

Index: device-mapper-test-suite/lib/dmtest/suites/insitu-comp.rb
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ device-mapper-test-suite/lib/dmtest/suites/insitu-comp.rb	2014-03-14 17:16:14.043519177 +0800
@@ -0,0 +1 @@
+require 'dmtest/tests/insitu-comp/insitu-comp_tests'
Index: device-mapper-test-suite/lib/dmtest/tests/insitu-comp/insitu-comp_tests.rb
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ device-mapper-test-suite/lib/dmtest/tests/insitu-comp/insitu-comp_tests.rb	2014-03-14 17:16:14.043519177 +0800
@@ -0,0 +1,120 @@
+require 'dmtest/config'
+require 'dmtest/git'
+require 'dmtest/log'
+require 'dmtest/utils'
+require 'dmtest/fs'
+require 'dmtest/tags'
+require 'dmtest/thinp-test'
+require 'dmtest/cache-status'
+require 'dmtest/disk-units'
+require 'dmtest/test-utils'
+require 'dmtest/tests/cache/fio_subvolume_scenario'
+
+require 'pp'
+
+#------------------------------------------------------------
+
+class InsitucompStack
+  include DM
+  include DM::LexicalOperators
+  include Utils
+
+  def initialize(dm, dev, opts)
+    @dm = dm
+    @dev = dev
+    @opts = opts
+  end
+
+  def activate(&block)
+   with_dev(table) do |comp|
+     @comp = comp
+     block.call(comp)
+   end
+  end
+
+  def table
+    total_blocks = dev_size(@dev) >> 3
+    data_blocks = total_blocks - 1
+    rem = data_blocks % (4096 * 8 + 5)
+    data_blocks /= 4096 * 8 + 5
+    meta_blocks = data_blocks * 5
+    data_blocks *= 4096 * 8
+
+    cnt = rem
+    rem /= (4096 * 8 / 5 + 1)
+    data_blocks += rem * (4096 * 8 / 5)
+    meta_blocks += rem
+
+    cnt %= (4096 * 8 / 5 + 1)
+    meta_blocks += 1
+    data_blocks += cnt - 1
+
+    sector_count = data_blocks << 3
+
+    writethrough = @opts.fetch(:writethrough, true)
+    if writethrough
+      t = Table.new(Target.new('insitu_comp', sector_count, @dev, 'writethrough'))
+    else
+      wb_interval = @opts.fetch(:writeback_interval, 5)
+      t = Table.new(Target.new('insitu_comp', sector_count, @dev, 'writeback', wb_interval))
+    end
+    t
+  end
+
+  private
+  def dm_interface
+    @dm
+  end
+end
+
+#------------------------------------------------------------
+
+class InsitucompTests < ThinpTestCase
+  include Utils
+  include DiskUnits
+  include FioSubVolumeScenario
+
+  def test_basic_setup_writethrough
+    test_basic_setup()
+  end
+
+  def test_basic_setup_writeback
+    test_basic_setup(false, 5)
+  end
+
+  def test_fio_writethrough
+    test_fio()
+  end
+
+  def test_fio_writeback
+    test_fio(false, 5)
+  end
+
+  private
+  def alloc_stack(writethrough, wbinterval)
+    if writethrough
+      stack = InsitucompStack.new(@dm, @data_dev, :writethrough => true)
+    else
+      stack = InsitucompStack.new(@dm, @data_dev, :writethrough => false, :writeback_interval => wbinterval)
+    end
+    stack
+  end
+
+  private
+  def test_basic_setup(writethrough = true, wbinterval = 5)
+    stack = alloc_stack(writethrough, wbinterval)
+    stack.activate do |comp|
+      wipe_device(comp)
+    end
+  end
+
+  private
+  def test_fio(writethrough = true, wbinterval = 5)
+    stack = alloc_stack(writethrough, wbinterval)
+    stack.activate do |comp|
+      do_fio(comp, :ext4,
+             :outfile => AP("fio_dm_insitu-comp" + (writethrough ? "-wt.out" : "-wb.out")),
+             :cfgfile => LP("tests/cache/database-funtime.fio"))
+    end
+  end
+end

--Nq2Wo0NMKNjxTN9z--
