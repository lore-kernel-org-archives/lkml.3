Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbaFZNXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 09:23:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304AbaFZNW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 09:22:59 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH] ring-buffer: Race when writing and swapping cpu buffer in parallel
Date: Thu, 26 Jun 2014 15:22:38 +0200
Message-Id: <1403788958-6751-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace/ring_buffer allows to swap the entire ring buffer. Everything has to
be done lockless. I think that I have found a race when trying to understand
the code. The problematic situation is the following:

CPU 1 (write/reserve event)		CPU 2 (swap the cpu buffer)
-------------------------------------------------------------------------
ring_buffer_write()
  if (cpu_buffer->record_disabled)
  ^^^ test fails and write continues

					ring_buffer_swap_cpu()

					  inc(&cpu_buffer_a->record_disabled);
					  inc(&cpu_buffer_b->record_disabled);

					  if (cpu_buffer_a->committing)
					  ^^^ test fails and swap continues
					  if (cpu_buffer_b->committing)
					  ^^^ test fails and swap continues

  rb_reserve_next_event()
    rb_start_commit()
      local_inc(&cpu_buffer->committing);
      local_inc(&cpu_buffer->commits);

    if (unlikely(ACCESS_ONCE(cpu_buffer->buffer) != buffer)) {
    ^^^ test fails and reserve_next continues

					  buffer_a->buffers[cpu] = cpu_buffer_b;
					  buffer_b->buffers[cpu] = cpu_buffer_a;
					  cpu_buffer_b->buffer = buffer_a;
					  cpu_buffer_a->buffer = buffer_b;

  Pheeee, reservation continues in the removed buffer.

This can be solved by a better check in rb_reserve_next_event(). The reservation
could continue only when "committing" is enabled and there is no swap in
progress or when any swap was not finished in the meantime.

Note that the solution is not perfect. It stops writing also in this situation:

CPU 1 (write/reserve event)		CPU 2 (swap the cpu buffer)
----------------------------------------------------------------------------
ring_buffer_write()
  if (cpu_buffer->record_disabled)
  ^^^ test fails and write continues

					ring_buffer_swap_cpu()

					  inc(&cpu_buffer_a->record_disabled);
					  inc(&cpu_buffer_b->record_disabled);

  rb_reserve_next_event()
    rb_start_commit()
      local_inc(&cpu_buffer->committing);
      local_inc(&cpu_buffer->commits);

					  if (cpu_buffer_a->committing)
					  ^^^ test passes and swap is canceled

    if (cpu_buffer->record_disabled)
    ^^^ test passes and reserve is canceled

					  dec(&cpu_buffer_a->record_disabled);
					  dec(&cpu_buffer_b->record_disabled);

  Pheeee, both actions were canceled. The write/reserve could have continued
  if the recording was enabled in time.

Well, it is the price for using lockless algorithms. I think that it happens
in more situations here, it is not worth more complicated code, and we could
live with it.

The patch also adds some missing memory barriers. Note that compiler barriers
are not enough because the data can be accessed by different CPUs.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/trace/ring_buffer.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7c56c3d06943..3020060ded7e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2529,13 +2529,15 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 
 #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
 	/*
-	 * Due to the ability to swap a cpu buffer from a buffer
-	 * it is possible it was swapped before we committed.
-	 * (committing stops a swap). We check for it here and
-	 * if it happened, we have to fail the write.
+	 * The cpu buffer swap could have started before we managed to stop it
+	 * by incrementing the "committing" values. If the swap is in progress,
+	 * we see disabled recording. If the swap has finished, we see the new
+	 * cpu buffer. In both cases, we should go back and stop committing
+	 * to the old buffer. See also ring_buffer_swap_cpu()
 	 */
-	barrier();
-	if (unlikely(ACCESS_ONCE(cpu_buffer->buffer) != buffer)) {
+	smp_mb();
+	if (unlikely(atomic_read(&cpu_buffer->record_disabled) ||
+		     ACCESS_ONCE(cpu_buffer->buffer) != buffer)) {
 		local_dec(&cpu_buffer->committing);
 		local_dec(&cpu_buffer->commits);
 		return NULL;
@@ -4334,6 +4336,13 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 	atomic_inc(&cpu_buffer_a->record_disabled);
 	atomic_inc(&cpu_buffer_b->record_disabled);
 
+	/*
+	 * We could not swap if a commit is in progress. Also any commit could
+	 * not start after we have stopped recording. Keep both checks in sync.
+	 * The counter part is in rb_reserve_next_event()
+	 */
+	smp_mb();
+
 	ret = -EBUSY;
 	if (local_read(&cpu_buffer_a->committing))
 		goto out_dec;
@@ -4348,6 +4357,12 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 
 	ret = 0;
 
+	/*
+	 * Mare sure that rb_reserve_next_event() see the right
+	 * buffer before we enable recording.
+	 */
+	smp_wmb();
+
 out_dec:
 	atomic_dec(&cpu_buffer_a->record_disabled);
 	atomic_dec(&cpu_buffer_b->record_disabled);
-- 
1.8.4

