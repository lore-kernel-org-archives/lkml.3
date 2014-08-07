Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbaHGMxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 08:53:48 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:48815 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757252AbaHGMwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 08:52:20 -0400
X-IronPort-AV: E=Sophos;i="5.01,818,1400018400"; 
   d="scan'208";a="88599290"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: coreteam@netfilter.org
Cc: kernel-janitors@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH 0/5] fix error return code
Date: Thu,  7 Aug 2014 14:49:04 +0200
Message-Id: <1407415749-19978-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The complate semantic patch that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
// identify a function that returns a negative return value at least once.
@ok exists@
identifier f,ret,i;
expression e;
constant c;
@@

f(...) {
... when any
(
return -c@i;
|
ret = -c@i;
... when != ret = e
return ret;
|
if (ret < 0) { ... return ret; }
)
... when any
}

// identify a case where the return variable is set to a non-negative value
// and then returned in error-handling code
@r exists@
identifier ret,ok.f,fn;
expression e1,e2,e3,e4,e5,e6,x;
statement S,S1;
position p1,p2,p3;
@@

f(...) {
... when any
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != \(ret = e1\|ret++\|ret--\|ret+=e1\|ret-=e1\)
    when != &ret
    when any
(
 if (<+... ret = e5 ...+>) S1
|
 if (<+... &ret ...+>) S1
|
if@p2(<+...x = fn(...)...+>)
 {
  ... when != ret = e6
      when forall
 return@p3 ret;
}
|
break;
|
x = fn(...)
... when != \(ret = e4\|ret++\|ret--\|ret+=e4\|ret-=e4\)
    when != &ret
(
 if (<+... ret = e3 ...+>) S
|
 if (<+... &ret ...+>) S
|
if@p2(<+...\(x != 0\|x < 0\|x == NULL\|IS_ERR(x)\)...+>)
 {
  ... when != ret = e2
      when forall
 return@p3 ret;
}
)
)
... when any
}

@printer depends on r@
position p;
identifier ok.f,pr;
constant char [] c;
@@

f(...) { <...pr@p(...,c,...)...> }

@bad0 exists@
identifier r.ret,ok.f,g != {ERR_PTR,IS_ERR};
position p != printer.p;
@@

f(...) { ... when any
g@p(...,ret,...)
... when any
 }

// ignore the above if there is some path where the variable is set to
// something else
@bad depends on !bad0 exists@
position r.p1,r.p2;
statement S1,S2;
identifier r.ret;
expression e1;
@@

(
if@p1 (\(ret < 0\|ret != 0\)) S1
|
ret@p1 = 0
)
... when any
 \(ret = e1\|ret++\|ret--\|ret+=e1\|ret-=e1\|&ret\)
... when any
if@p2(...) S2

@bad1 depends on !bad0 && !bad exists@
position r.p2;
statement S2;
identifier r.ret;
expression e1;
constant c;
@@

ret = -c
... when != \(ret = e1\|ret++\|ret--\|ret+=e1\|ret-=e1\)
    when != &ret
    when any
if@p2(...) S2

// likewise ignore it if there has been an intervening return
@bad2 depends on !bad0 && !bad && !bad1 exists@
position r.p1,r.p2;
identifier r.ret;
expression e1;
statement S2;
constant c;
@@

ret@p1 = 0
... when != if (...) { ... ret = e1 ... return ret; }
    when != if (...) { ... return -c; }
    when any
if@p2(...) S2


@script:python depends on !bad0 && !bad && !bad1 && !bad2@
p1 << r.p1;
p2 << r.p2;
p3 << r.p3;
@@

cocci.print_main("",p1)
cocci.print_secs("",p2)
cocci.print_secs("",p3)
// </smpl>

