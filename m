Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaLCKbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:31:15 -0500
Received: from mout.web.de ([212.227.15.3]:50470 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaLCKbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:31:13 -0500
Message-ID: <547EE653.5000901@users.sourceforge.net>
Date: Wed, 03 Dec 2014 11:30:43 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Mark D. Rustad" <mrustad@gmail.com>, Walter Harms <wharms@bfs.de>
CC: Coccinelle <cocci@systeme.lip6.fr>, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: Determination for the number of named function parameters (with
 SmPL)
References: <547C4D11.1050206@users.sourceforge.net> <8DDAD79C-96D4-43BA-BC3F-F9EE237D2C60@gmail.com>
In-Reply-To: <8DDAD79C-96D4-43BA-BC3F-F9EE237D2C60@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:gZCgcbhB6cYEWpNtCUuzFBBWqadgA1y3ILkP8WKk8NDn280IsVu
 rNlhWZcxpclZeCSRVyhEesBJYBJB46Z58rWtCMLHqBxYrF7uMjCsC554D3LhOGyqyIDuEp3
 4kCOoRWhNuS3meh0Tc/DIsEmNi9X21c2mFrDFy3MkgGkXoSNNL+ZLOlWFxi0FMEfhyKP8iL
 potTAdfUtUZcQ8DAc4VqQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> elfring@Sonne:~/Projekte/Coccinelle/Probe> cat list_parameter_numbers1.txt
>> number|counter
>> 0|29
> 
> I think the results are dubious. Only 29 functions with no parameters?
> That can't be right.

How do you think about to experiment a bit more with the following
semantic query approach?

@initialize:python@
@@
import sys
import sqlite3 as SQLite
connection = SQLite.connect(":memory:")
c = connection.cursor()
c.execute("""
create table numbers
(parameter_number integer,
 function text,
 source_file text,
 line integer,
 column integer,
 constraint c
 primary key (function, source_file, line, column)
)
without rowid""")

def store_number(count, fun, places):
    """Add an integer to an internal list."""
    for place in places:
        c.execute("""insert into numbers
(parameter_number,
 function,
 source_file,
 line,
 column
)
values (?, ?, ?, ?, ?)""",
                  (count,
                   fun,
                   place.file,
                   place.line,
                   int(place.column) + 1
                  )
                 )

@counting_parameters@
identifier work;
parameter list[number] pl;
position pos;
type return_type;
@@
 return_type work@pos(pl)
 {
  ...
 }

@script:python collection@
count << counting_parameters.number;
fun << counting_parameters.work;
places << counting_parameters.pos;
@@
store_number(count, fun, places)

@finalize:python@
@@
c.execute("""select count(*) nr from numbers""")
result = c.fetchone()

if result[0] > 0:
   c.execute("""create index x on numbers (parameter_number)""")
   c.execute("""select *
from numbers
where parameter_number > 12
order by parameter_number desc, function, source_file""")
   delimiter = "|"
   mark1 = ['"', '', '"']
   mark2 = ['"', '', '"']
   sys.stdout.write(delimiter.join(('"parameter number"',
                                    "function",
                                    '"source file"',
                                    "line",
                                    "column"
                                   )))
   sys.stdout.write("\r\n")
   for entry in c:
      mark1[1] = entry[1]
      mark2[1] = entry[2].replace('"', '""')
      sys.stdout.write(delimiter.join((str(entry[0]),
                                       ''.join(mark1),
                                       ''.join(mark2),
                                       str(entry[3]),
                                       str(entry[4])
                                      )))
      sys.stdout.write("\r\n")
else:
   sys.stderr.write("No result for this analysis!\n")

connection.close()


elfring@Sonne:~/Projekte/Linux/next-patched> XX=$(date) && spatch.opt -timeout 12 -sp-file ~/Projekte/Coccinelle/Probe/list_parameter_numbers1b.cocci -dir . > list_parameter_numbers1b.txt 2> list_parameter_numbers1b-errors.txt ; YY=$(date) && echo "$XX * $YY"
Mi 3. Dez 08:46:17 CET 2014 * Mi 3. Dez 09:13:14 CET 2014
elfring@Sonne:~/Projekte/Linux/next-patched> cat list_parameter_numbers1b.txt
"parameter number"|function|"source file"|line|column
22|"send_cap_msg"|"./fs/ceph/caps.c"|968|12
21|"dispc_ovl_setup_common"|"./drivers/video/fbdev/omap2/dss/dispc.c"|2414|12
...
13|"src_sync_cmd"|"./drivers/scsi/aacraid/src.c"|172|12
13|"submit_extent_page"|"./fs/btrfs/extent_io.c"|2761|12


Regards,
Markus
