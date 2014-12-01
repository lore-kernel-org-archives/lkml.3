Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaLALMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:12:24 -0500
Received: from mout.web.de ([212.227.15.4]:60750 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbaLALMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:12:22 -0500
Message-ID: <547C4D11.1050206@users.sourceforge.net>
Date: Mon, 01 Dec 2014 12:12:17 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: kernel-janitors@vger.kernel.org
CC: Coccinelle <cocci@systeme.lip6.fr>, LKML <linux-kernel@vger.kernel.org>
Subject: Determination for the number of named function parameters (with SmPL)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:T1B72DPCmBPn5x+NM/LPkndjY9VxiiiWaS1EKYX6KYVfCeNTRyU
 NURmIjUCSjeCbtH+e60v92Focs1s+1wy3cvvum1l4lKBHxBsC+u4ImCAR+hgsUgZjpOuvaE
 oymkeM/XkEvR3wPpUymPAbo3Hkubek6CgHVpKC1z3bZIhyjclsJbV4G/zSTgdU9zQqeXBo/
 43u/e9hIgB1KxBr5C4A3g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Would you like to know how many named function parameters are used in the source files?

How do you think about to try the following semantic query approach out a bit more?

@initialize:python@
@@
import sys
import sqlite3 as SQLite
connection = SQLite.connect(":memory:")
c = connection.cursor()
c.execute("""create table numbers (number integer)""")
delimiter = "|"

def store_number(count):
    """Add an integer to an internal list."""
    c.execute("""insert into numbers (number) values (?)""",
              (count, )
             )

@counting_parameters@
identifier work;
parameter list[number] pl;
type return_type;
@@
 return_type work(pl)
 {
  ...
 }

@script:python collection@
count << counting_parameters.number;
@@
store_number(count)

@finalize:python@
@@
c.execute("""select count(*) nr from numbers""")
result = c.fetchone()

if result[0] > 0:
   c.execute("""create index x on numbers (number)""")
   c.execute("select number, count(*) nr from numbers group by number")
   sys.stdout.write(delimiter.join( ("number", "counter") ))
   sys.stdout.write("\r\n")
   for result in c:
      sys.stdout.write(delimiter.join((str(result[0]),
                                       str(result[1])
                                      )))
      sys.stdout.write("\r\n")
else:
   sys.stderr.write("No result for this analysis!\n")

connection.close()



elfring@Sonne:~/Projekte/Coccinelle/Probe> XX=$(date) && spatch.opt -timeout 12 -sp-file list_parameter_numbers1.cocci -dir /usr/src/linux-stable > list_parameter_numbers1.txt 2> list_parameter_numbers1-errors.txt ; YY=$(date) && echo "$XX * $YY"
...
elfring@Sonne:~/Projekte/Coccinelle/Probe> cat list_parameter_numbers1.txt
number|counter
0|29
1|18261
2|15374
3|12237
4|8159
5|4339
6|2701
7|1183
8|518
9|260
10|146
11|83
12|42
13|21
14|9
15|7
16|2
17|4
18|1
21|1
22|1


Do you find such an analysis result from the source files for Linux 3.17.4
interesting for further considerations?

Regards,
Markus
