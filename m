Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaCJBCp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 21:02:45 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:39244 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbaCJBCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 21:02:43 -0400
X-Originating-IP: 50.43.32.211
Date: Sun, 9 Mar 2014 18:02:37 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/5] bug: Make BUG() always stop the machine
Message-ID: <71630a037c1a76e270e0a5cb8dd7272a73141a08.1394412745.git.josh@joshtriplett.org>
References: <17c859aa7dcccec43df0a0c8908911b982764c76.1394412745.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17c859aa7dcccec43df0a0c8908911b982764c76.1394412745.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When !CONFIG_BUG and !HAVE_ARCH_BUG, define the generic BUG() as an
infinite loop rather than a no-op.  This avoids undefined behavior if
execution ever actually reaches BUG(), and avoids warnings about code
after BUG() (such as on non-void functions calling BUG() and then
not returning).

bloat-o-meter results:

add/remove: 0/0 grow/shrink: 43/10 up/down: 235/-98 (137)
function                                     old     new   delta
umount_collect                               119     138     +19
notify_change                                306     324     +18
xstate_enable_boot_cpu                       252     269     +17
kunmap                                        54      70     +16
balloon_page_dequeue                         112     126     +14
mm_take_all_locks                            223     233     +10
list_lru_walk_node                           143     152      +9
vma_adjust                                  1059    1067      +8
pcpu_setup_first_chunk                      1130    1138      +8
mm_drop_all_locks                            143     151      +8
ns_capable                                    55      62      +7
anon_transport_class_unregister                8      15      +7
srcu_init_notifier_head                       35      41      +6
shrink_dcache_for_umount                     174     180      +6
kunmap_high                                   99     105      +6
end_page_writeback                            43      49      +6
do_exit                                     1339    1345      +6
__kfifo_dma_out_prepare_r                     86      92      +6
__kfifo_dma_in_prepare_r                      90      96      +6
fixup_user_fault                             120     125      +5
repair_env_string                             73      77      +4
read_cache_pages_invalidate_page              56      60      +4
isolate_lru_pages.isra                       142     146      +4
do_notify_parent_cldstop                     255     259      +4
cpu_init                                     370     374      +4
utimes_common                                270     272      +2
tasklet_hi_action                             91      93      +2
tasklet_action                                91      93      +2
set_pte_vaddr                                 46      48      +2
find_get_pages_tag                           202     204      +2
early_iounmap                                185     187      +2
__native_set_fixmap                           36      38      +2
__get_user_pages                             822     824      +2
__early_ioremap                              299     301      +2
yield_task_stop                                1       2      +1
tick_resume                                   37      38      +1
switched_to_stop                               1       2      +1
switched_to_idle                               1       2      +1
prio_changed_stop                              1       2      +1
prio_changed_idle                              1       2      +1
pm_qos_power_read                            111     112      +1
arch_cpu_idle_dead                             1       2      +1
__insert_vmap_area                           140     141      +1
sys_renameat                                 614     612      -2
mm_fault_error                               297     295      -2
SyS_renameat                                 614     612      -2
sys_linkat                                   416     413      -3
SyS_linkat                                   416     413      -3
chmod_common                                 129     122      -7
proc_cap_handler                             240     225     -15
__schedule                                   849     831     -18
sys_madvise                                 1077    1054     -23
SyS_madvise                                 1077    1054     -23

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
v3: New patch in this series, incorporating Arnd's suggestion to make BUG()
always stop execution.  This eliminates the new warnings currently appearing in
allnoconfig due to !CONFIG_BUG; unlike v2, this avoids using unreachable(), and
thus avoids the possibility of undefined behvior if execution actually reaches
a call to BUG().

 include/asm-generic/bug.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index a97fa11..630dd23 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -138,7 +138,7 @@ extern void warn_slowpath_null(const char *file, const int line);
 
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
-#define BUG() do {} while (0)
+#define BUG() do {} while (1)
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-- 
1.9.0

