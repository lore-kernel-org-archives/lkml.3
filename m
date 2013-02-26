Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab3BZF7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:59:15 -0500
Received: from nm36-vm8.bullet.mail.sg3.yahoo.com ([106.10.151.95]:40797 "EHLO
	nm36-vm8.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275Ab3BZF7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:59:14 -0500
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2013 00:59:12 EST
X-Yahoo-Newman-Id: 968749.82824.bm@smtp128.mail.sg3.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: tYXNM_cVM1k33B4TvrWrOZTlHasi.Wk7bYiGHlckywuBjns
 4rWg1jDOYkXiVkZuYeQVoAD0awCJtRDtUz.TPpXFzocKeErQzbismYcL72Ab
 qxhv83o2tSDdxQqahoMZ3PCCzwRnAImMK5NuVqKyIZCUPR_NMFda8W1ddklP
 yjUPWJJEiuYDO0cxHnEmMic9T81Mybz8nw7DTLVPzCdFbdQh6y1JFQzlzm0C
 iaJYXPr7mke4eL7slwXGW0smdWvzkkJ.L.vRC2fQsdvDG0TlNql8Lv_.3p9L
 ITdRNOGqXggdfVeOX.w9q.h8OUKGnVa.buFkul1B5fL6LssqjcMPiHjsHKaT
 BqWe0v.KltBaNi.VPe6Pr6E4Lam6J1pqMz.RNXdCZddY.QPCJb73vJuuwZ4c
 QKq4a0QxokQUpfpTZCfi_K2DsF2jCZGNQKjJ6F9FFnOZNPw--
X-Yahoo-SMTP: tW.h3tiswBBMXO2coYcbPigGD5Lt6zY_.Zc-
From: Marek Lindner <lindner_marek@yahoo.de>
To: b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [B.A.T.M.A.N.] batman-adv: gpf in batadv_slide_own_bcast_window
Date: Tue, 26 Feb 2013 13:52:46 +0800
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Antonio Quartulli <ordex@autistici.org>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Dave Jones <davej@redhat.com>, "David S. Miller" <davem@davemloft.net>
References: <5127A2AF.9030502@oracle.com> <20130222170621.GU3523@ritirata.org> <5127BAD2.1040007@oracle.com>
In-Reply-To: <5127BAD2.1040007@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302261352.47191.lindner_marek@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 23, 2013 02:37:06 Sasha Levin wrote:
> I'm confused about how batadv_orig_hash_del_if removes an interface from
> the hashtable. I see the hashtable is using rcu to protect it, but when we
> delete an entry we free it straight away by calling
> batadv_orig_node_del_if() and not going through kfree_rcu().
> 
> Is there a reason behind doing that, or might it be the cause of the
> problem we're seeing here?

Maybe I am overlooking something but it seems to me access to this memory is 
protected by the same lock: orig_node->ogm_cnt_lock
Before batadv_orig_node_del_if() is called this lock is acquired and 
batadv_slide_own_bcast_window() also attempts acquire the orig_node-
>ogm_cnt_lock spinlock before writing to this chunk of memory.

Do we know for certain that batadv_orig_hash_del_if() is involved or is that a 
guess at this point ? If you ask me the next for-loop in 
batadv_orig_hash_del_if() looks more suspicious than the first one. The 
interfaces get renumbered without any protection. Could be a regression from 
the orig_hash_lock removal (the comments refer to a now inexisting lock).

Cheers,
Marek
