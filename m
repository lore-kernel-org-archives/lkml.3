Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab3KLO4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:56:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951Ab3KLOzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:55:52 -0500
Subject: Re: [RFC] Coverity 1128444 - Dereference after null check
 (FORWARD_NULL) in glock.c
From: Steven Whitehouse <swhiteho@redhat.com>
To: Geyslan =?ISO-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Cc: cluster-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CAGG-pUSSBi7+AmN09hVLeD0Qu-uA7iRPepMtr7X154yfbK4C6A@mail.gmail.com>
References: <CAGG-pUSSBi7+AmN09hVLeD0Qu-uA7iRPepMtr7X154yfbK4C6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 12 Nov 2013 14:55:37 +0000
Message-ID: <1384268137.2697.10.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2013-11-12 at 12:53 -0200, Geyslan Gregório Bem wrote:
> Hello,
> 
> Coverity detected in 'fs/gfs2/glock.c' a possible dereference after
> null check. Maybe a positive one.
> 
> There is a initial check for possible 'gl' NULL. After that 'gl' is
> dereferenced in the looping check by __lockref_is_dead().
> 
> What do you think?
> 
I've already been sent a patch for that, and its in the GFS2 -fixes
tree. Thanks,

Steve.

> 
> 1875static int gfs2_glock_iter_next(struct gfs2_glock_iter *gi)
> 1876{
> 1877        struct gfs2_glock *gl;
> 1878
> 1879        do {
> 1880                gl = gi->gl;
> 
> 1. Condition "gl", taking false branch
> 
> 2. var_compare_op: Comparing "gl" to null implies that "gl" might be null.
> 1881                if (gl) {
> 1882                        gi->gl = glock_hash_next(gl);
> 1883                        gi->nhash++;
> 1884                } else {
> 
> 3. Condition "gi->hash >= (32768 /* 1 << 15 */)", taking false branch
> 1885                        if (gi->hash >= GFS2_GL_HASH_SIZE) {
> 1886                                rcu_read_unlock();
> 1887                                return 1;
> 1888                        }
> 1889                        gi->gl = glock_hash_chain(gi->hash);
> 1890                        gi->nhash = 0;
> 1891                }
> 
> 4. Condition "gi->gl == NULL", taking true branch
> 
> 7. Condition "gi->gl == NULL", taking false branch
> 1892                while (gi->gl == NULL) {
> 1893                        gi->hash++;
> 
> 5. Condition "gi->hash >= (32768 /* 1 << 15 */)", taking false branch
> 1894                        if (gi->hash >= GFS2_GL_HASH_SIZE) {
> 1895                                rcu_read_unlock();
> 1896                                return 1;
> 1897                        }
> 1898                        gi->gl = glock_hash_chain(gi->hash);
> 1899                        gi->nhash = 0;
> 
> 6. Jumping back to the beginning of the loop
> 1900                }
> 1901        /* Skip entries for other sb and dead entries */
> 
> 8. Condition "gi->sdp != gi->gl->gl_sbd", taking false branch
> 
> CID 1128444 (#1 of 1): Dereference after null check (FORWARD_NULL)9.
> var_deref_model: Passing null pointer "&gl->gl_lockref" to function
> "__lockref_is_dead(struct lockref const *)", which dereferences
> it.[show details]
> 1902        } while (gi->sdp != gi->gl->gl_sbd ||
> __lockref_is_dead(&gl->gl_lockref));
> 1903
> 1904        return 0;
> 1905}
> 


