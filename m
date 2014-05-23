Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaEWIkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:40:07 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:59917 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaEWIkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:40:01 -0400
Message-ID: <537F0951.5010904@lab.ntt.co.jp>
Date: Fri, 23 May 2014 17:39:45 +0900
From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jon Maxwell <jmaxwell@redhat.com>
CC: Jon Maxwell <jmaxwell37@gmail.com>, stephen@networkplumber.org,
        davem@davemloft.net, vyasevic@redhat.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpirko@redhat.com
Subject: Re: [PATCH net] bridge: notify user space of fdb port change
References: <1399967708-7283-1-git-send-email-jmaxwell@redhat.com> <5372BA1E.8000402@lab.ntt.co.jp> <2052318198.6465872.1400101664337.JavaMail.zimbra@redhat.com> <1679971005.11740655.1400821172875.JavaMail.zimbra@redhat.com>
In-Reply-To: <1679971005.11740655.1400821172875.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/23 13:59), Jon Maxwell wrote:
...
> Makita-san,
> 
> I recoded this using your idea and ran it through a reproducer.
> It work fine. After some more consideration I agree that 
> setting fdb->dst = source is only required when source != fdb->dst.
> 
> Thanks for your suggestions. This is the revised patch. It should 
> retain the original behaviour except for the notify after the fdb update.  
> 
> Please let me know if you have any further input?

I have no more comments except for style problems (bracket position,
indentation, type mismatch).
thank you for rewriting :)

Thanks,
Toshiaki Makita

> 
> $ diff -Naur br_fdb.c br_fdb.c.patch
> --- br_fdb.c        2014-05-17 12:43:23.346319609 +1000
> +++ br_fdb.c.patch        2014-05-17 16:54:46.280235728 +1000
> @@ -487,6 +487,7 @@
>  {
>          struct hlist_head *head = &br->hash[br_mac_hash(addr, vid)];
>          struct net_bridge_fdb_entry *fdb;
> +        bool fdb_modified = 0;
>  
>          /* some users want to always flood. */
>          if (hold_time(br) == 0)
> @@ -507,10 +508,16 @@
>                                          source->dev->name);
>                  } else {
>                          /* fastpath: update of existing entry */
> -                        fdb->dst = source;
> +                        if (unlikely(source != fdb->dst))
> +                                {
> +                                fdb->dst = source;
> +                                fdb_modified = 1;
> +                                }
>                          fdb->updated = jiffies;
>                          if (unlikely(added_by_user))
>                                  fdb->added_by_user = 1;
> +                        if (unlikely(fdb_modified))
> +                                fdb_notify(br, fdb, RTM_NEWNEIGH);
>                  }
>          } else {
>                  spin_lock(&br->hash_lock);
> 
> 
